Pod::Spec.new do |s|
  s.name         = 'DRGlyphLabel'
  s.version      = '0.1.0'
  s.summary      = 'A simple library that allows you to create labels with bitmap fonts in UIKit'
  s.homepage     = 'https://github.com/darrarski/DRGlyphLabel-iOS'
  s.license      = 'MIT'
  s.author       = { 'Darrarski' => 'darrarski@gmail.com' }
  s.source       = { :git => 'https://github.com/darrarski/DRGlyphLabel-iOS.git', :tag => '0.1.0' }
  s.platform     = :ios
  s.ios.deployment_target = '7.0'
  s.source_files = 'DRGlyphLabel'
  s.requires_arc = true
end
