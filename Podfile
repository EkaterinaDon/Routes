# Uncomment the next line to define a global platform for your project
 platform :ios, '14.0'

target 'Routes' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Routes
    pod 'GoogleMaps', '5.0.0'
    pod 'RealmSwift', '=10.8.0'

    pod 'RxSwift', '6.2.0'
    pod 'RxCocoa', '6.2.0'
end

post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
  end
end