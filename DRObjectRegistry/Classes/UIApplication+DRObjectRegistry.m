//
//  UIApplication+DRObjectRegistry.m
//  DRObjectRegistry
//
//  Created by Nate Petersen on 8/29/13.
//  Copyright (c) 2013 Digital Rickshaw. All rights reserved.
//

#import "UIApplication+DRObjectRegistry.h"
#import <objc/runtime.h>
#import "DRReadWriteLock.h"

static const char kLockKey;
static const char kRegistryKey;

@implementation UIApplication (DRObjectRegistry)

- (DRReadWriteLock*) dr_readWriteLock {
	DRReadWriteLock* theLock = objc_getAssociatedObject(self, &kLockKey);
	
	if (!theLock) {
		@synchronized(self) {
//			NSLog(@"in synchronized block");
			
			theLock = objc_getAssociatedObject(self, &kLockKey);
			
			if (!theLock) {
//				NSLog(@"creating lock");
				theLock = [[DRReadWriteLock alloc] init];
				objc_setAssociatedObject(self, &kLockKey, theLock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
			}
		}
	}
	
	return theLock;
}

- (NSMutableDictionary*)dr_registry {
	__block NSMutableDictionary* registry = objc_getAssociatedObject(self, &kRegistryKey);
	
	if (!registry) {
		DRReadWriteLock* lock = [self dr_readWriteLock];
		
		[lock executeInWriteLock:^{
//			NSLog(@"in critical section");
			registry = objc_getAssociatedObject(self, &kRegistryKey);
			
			if (!registry) {
//				NSLog(@"creating registry");
				registry = [[NSMutableDictionary alloc] init];
				objc_setAssociatedObject(self, &kRegistryKey, registry, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
			}
		}];
	}
	
	return registry;
}

- (void)registerObject:(id)object forKey:(NSString*)key {
	
	DRReadWriteLock* lock = [self dr_readWriteLock];
	NSMutableDictionary* registry = [self dr_registry];
	
	[lock executeInWriteLock:^{
		[registry setObject:object forKey:key];
	}];
}

- (id)registeredObjectForKey:(NSString*)key {
	DRReadWriteLock* lock = [self dr_readWriteLock];
	NSMutableDictionary* registry = [self dr_registry];
	
	__block id result = nil;
	
	[lock executeInReadLock:^{
		result = [registry objectForKey:key];
	}];
	
	return result;
}

@end
