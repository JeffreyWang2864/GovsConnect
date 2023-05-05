platform :ios, '12.0'

target 'GovsConnect' do
  use_frameworks!
  pod 'IQKeyboardManagerSwift'
  pod 'TwicketSegmentedControl'
  pod 'TBDropdownMenu'
  pod 'Alamofire'
  pod 'SwiftyJSON'
  pod 'ReachabilitySwift'
  pod 'RSKImageCropper'
  pod 'Google/SignIn'
  pod 'CSV.swift'
  pod 'SwiftyGif'
  pod 'PinterestSegment'
  pod 'Instructions'
end

post_install do |installer|
    installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
               end
          end
   end
end

#target 'ScheduleWidgetExtension' do
#  use_frameworks!
#  pod 'Alamofire'
#  pod 'SwiftyJSON'
#  pod 'ReachabilitySwift'
#end
