# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

target 'preparationApp' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for preparationApp
  pod 'Alamofire', '~> 5.4'
  pod 'GoogleSignIn'
  pod 'Firebase/Core'
  pod 'Firebase/Auth'
  pod 'MessageKit'
  pod 'Firebase/Firestore'
  pod 'FirebaseMessaging'
  pod 'SDWebImage'
  pod 'Firebase/Database'
  
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      #config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
      #config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '10.0'
      #config.build_settings["ONLY_ACTIVE_ARCH"] = "YES"
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      config.build_settings['EXPANDED_CODE_SIGN_IDENTITY'] = ""
      config.build_settings['CODE_SIGNING_REQUIRED'] = "NO"
      config.build_settings['CODE_SIGNING_ALLOWED'] = "NO"
      config.build_settings['ENABLE_BITCODE'] = 'NO'
    end
  end
end
