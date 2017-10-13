#
#  Be sure to run `pod spec lint ExpandableCalendar.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "ExpandableCalendar"
  s.version      = "1.0.0"
  s.summary      = "Week and Month View of Calendar. Customizable"
  s.description  = "Choose to display calendar in both week and month modes, from a current date to any other date"
  s.homepage     = "https://www.raywenderlich.com/126365/ios-frameworks-tutorial"
  s.license      = "MIT"
  s.author       = "Sowmya"
  s.platform     = :ios
  s.platform     = :ios, "5.0"
  s.source       = { :git => "http://EXAMPLE/ThreeRingControl.git", :tag => "#{s.version}" }
  s.source_files  = "ExpandableCalendar", "ExpandableCalendar/**/*.{h,m,swift}"
  end
