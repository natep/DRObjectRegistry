Pod::Spec.new do |s|
  s.name         = 'DRObjectRegistry'
  s.version      = '0.0.1'
  s.platform     = :ios
  s.license      = 'BSD'
  s.homepage     = 'http://github.com/natep/DRObjectRegistry'
  s.summary      = 'A runtime registry for objects.'
  s.author       = { 'Nate Petersen' => 'nate@digitalrickshaw.com' }
  s.source       = { :git => 'https://github.com/natep/DRObjectRegistry.git', :tag => '0.0.1' }
  s.source_files = 'DRObjectRegistry/Classes'
  s.requires_arc = true
  s.dependency     'LockBlocks'
end
