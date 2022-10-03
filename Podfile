# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

def shared_pods
  use_frameworks!
  pod 'SnapKit', '~> 5.6.0'
  pod 'Then'
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'Moya/RxSwift'
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
