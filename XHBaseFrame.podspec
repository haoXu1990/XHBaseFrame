#
# Be sure to run `pod lib lint XHBaseFrame.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'XHBaseFrame'
  s.version          = '0.1.0'
  s.summary          = 'iOS App basic Framework'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/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/XHBaseFrame'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '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' => '286089659@qq.com' }
  s.source           = { :git => 'https://github.com/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/XHBaseFrame.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'
  s.swift_version = '5.0'

  s.source_files = 'XHBaseFrame/Classes/**/*'
  
  # s.resource_bundles = {
  #   'XHBaseFrame' => ['XHBaseFrame/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
   s.frameworks = 'UIKit'
   s.dependency 'Moya/RxSwift', '14.0.0'
   s.dependency 'RxTheme', '4.1.1'
   s.dependency 'RxDataSources', '4.0.1'
   s.dependency 'NSObject+Rx', '5.1.0'
   s.dependency 'ObjectMapper', '4.2.0'
   s.dependency 'ReactorKit', '2.1.1'
   s.dependency 'URLNavigator', '2.3.0'
   s.dependency 'SwifterSwift', '5.2.0'
   s.dependency 'Kingfisher', '5.15.7'
   s.dependency 'DZNEmptyDataSet', '1.8.1'
end
