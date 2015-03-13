#
#  Be sure to run `pod spec lint NXTSegmentedControl.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name             = "NXTSegmentedControl"
  s.version          = "1.0.2"
  s.summary          = "A segmented control replacement that supports swiping, and animated transitions."
  s.homepage         = "https://github.com/YayNext/NXTSegmentedControl"
  
  s.license          = { :type => "MIT", :file => "LICENSE" }
  
  s.author           = { "Patrick Mick" => "patrickmick1@gmail.com" }
  s.social_media_url = "http://twitter.com/patrickmick"
  
  s.platform         = :ios
  
  s.source           = { :git => "https://github.com/YayNext/NXTSegmentedControl.git", :tag => "1.0.2" }
  
  s.source_files     = "Classes", "NXTSegmentedControl/*.{h,m}"
  
  s.requires_arc     = true

end
