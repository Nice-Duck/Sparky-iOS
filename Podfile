# Uncomment the next line to define a global platform for your project
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '12.0'

def shared_pods
  use_frameworks!
  pod 'SnapKit', '~> 5.6.0'
  pod 'Then'
  pod 'RxSwift'
  pod 'RxCocoa'
  pod "RxGesture"
  pod 'Moya/RxSwift'
  pod 'Alamofire'
#  pod 'SwiftSoup'
  pod 'SwiftLinkPreview', '~> 3.4.0'
  pod 'Kingfisher', '~> 7.0'
  pod 'lottie-ios'
  pod 'Toast-Swift', '~> 5.0.1'
end

target 'Sparky-iOS' do
  shared_pods
end

target 'Sparky' do
  shared_pods
end

target 'Sparky-iOSTests' do
  inherit! :search_paths
  # Pods for testing
end

target 'Sparky-iOSUITests' do
  # Pods for testing
end
