#
# Be sure to run `pod lib lint ScanAndPay.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ScanAndPay'
  s.version          = '0.1.0'
  s.summary          = 'Poland scan and pay implementation'
  s.swift_version    = '5.0'
  s.description      = <<-DESC
QR code transfers
                       DESC

  s.homepage         = 'https://github.com/santander-group-europe'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'pgorzelany-st' => '188216@santander.pl' }
  s.source           = { :git => 'https://github.com/santander-group-europe/ios-poland.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.3'

  s.source_files = 'ScanAndPay/Features/**/*.{swift}'

  s.resource_bundles = {
    'ScanAndPay' => ['ScanAndPay/Assets/*{xib,xcassets}']
  }
  
  s.dependency "UI"
  s.dependency "PLUI"
  s.dependency "SANPLLibrary"
  s.dependency "PLCommons"
  s.dependency "Operative"
  s.dependency "PLCommonOperatives"
end
