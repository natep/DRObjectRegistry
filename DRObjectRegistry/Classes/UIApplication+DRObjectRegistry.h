//
//  UIApplication+DRObjectRegistry.h
//  DRObjectRegistry
//
//  Created by Nate Petersen on 8/29/13.
//  Copyright (c) 2013 Digital Rickshaw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (DRObjectRegistry)

- (void)registerObject:(id)object forKey:(NSString*)key;

- (id)registeredObjectForKey:(NSString*)key;

@end
