#
# Be sure to run `pod lib lint HttpSessionManager.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HttpSessionManager'
  s.version          = '1.0.0'
  s.summary          = 'Http网络请求管理库'
  s.swift_version    = '4.2'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
Simple and convenient network request lib, based Alamofire.
                       DESC

  s.homepage         = 'https://github.com/zhengrusong/HttpSessionManager'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'zhengrusong' => '707597767@qq.com' }
  s.source           = { :git => 'https://github.com/zhengrusong/HttpSessionManager.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'HttpSessionManager/Classes/**/*'
  s.dependency 'Alamofire', '~> 4.8.2'
  s.dependency 'SwiftyJSON', '4.2.0'

  # s.resource_bundles = {
  #   'HttpSessionManager' => ['HttpSessionManager/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
