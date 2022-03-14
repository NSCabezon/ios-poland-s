#
# Be sure to run `pod lib lint ZusTransfer.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ZusSMETransfer'
  s.version          = '0.1.0'
  s.summary          = 'Poland ZUS SME transfer implementation'
  s.swift_version    = '5.0'
  s.description      = <<-DESC
  The ZusTransfer framework
                       DESC

  s.homepage         = 'https://github.com/santander-group-europe'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'paweltrojan' => 'Pawel.Trojan@santander.pl' }
  s.source           = { :git => 'https://github.com/santander-group-europe/ios-poland.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.3'

  s.source_files = 'ZusSMETransfer/**/*.{swift}'
  s.resource_bundles = { 'ZusSMETransfer' => ['ZusSMETransfer/Assets/*{xib,xcassets}'] }
  
  s.dependency "UI"
  s.dependency "PLUI"
  s.dependency "SANPLLibrary"
  s.dependency "PLCommons"
  s.dependency "Operative"
  s.dependency "PLCryptography"
  s.dependency "PLCommonOperatives"
  s.dependency 'OpenCombine', '~> 0.12.0'
  s.dependency 'OpenCombineDispatch', '~> 0.12.0'
  s.dependency 'OpenCombineFoundation', '~> 0.12.0'
end
