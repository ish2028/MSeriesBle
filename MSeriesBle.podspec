#
# Be sure to run `pod lib lint MSeriesBle.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
s.name             = 'MSeriesBle'
s.version          = '1.0.2'
s.summary          = 'Listens for Keiser\'s M Series Bike line.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

s.description      = <<-DESC
Uses BLE to scan for M Series bikes and stores the machines so we can listen to specific machines.
DESC

s.homepage         = 'https://github.com/ish2028/MSeriesBle'
# s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'imartinez2028@gmail.com' => 'imartinez2028@gmail.com' }
s.source           = { :git => 'https://github.com/ish2028/MSeriesBle.git', :tag => s.version.to_s }
# s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

s.ios.deployment_target = '9.0'

s.source_files = 'MSeriesBle/Classes/**/*'

# s.resource_bundles = {
#   'MSeriesBle' => ['MSeriesBle/Assets/*.png']
# }

# s.public_header_files = 'Pod/Classes/**/*.h'
 s.frameworks = 'UIKit', 'CoreBluetooth'
# s.dependency 'AFNetworking', '~> 2.3'
end

