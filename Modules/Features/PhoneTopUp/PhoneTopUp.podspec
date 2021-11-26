#
# Be sure to run `pod lib lint PhoneTopUp.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PhoneTopUp'
  s.version          = '0.0.1'
  s.summary          = 'Poland phone top-up implementation'
  s.swift_version    = '5.0'
  s.description      = <<-DESC
  The phone top-up feature
                       DESC

  s.homepage         = 'https://github.com/santander-group-europe'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'piotr.gorzelany' => '188216@santander.pl' }
  s.source           = { :git => 'https://github.com/santander-group-europe/ios-poland.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.3'

  s.source_files = 'PhoneTopUp/Features/**/*.{swift}'

  s.resource_bundles = {
    'PhoneTopUp' => ['PhoneTopUp/Assets/**/*{xib,xcassets}']
  }

  s.dependency "UI"
  s.dependency "PLUI"
  s.dependency "SANPLLibrary"
  s.dependency "PLCommons"
  s.dependency "Operative"
  s.dependency "PLCommonOperatives"
end
