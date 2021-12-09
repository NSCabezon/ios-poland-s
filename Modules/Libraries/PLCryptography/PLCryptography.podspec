#
# Be sure to run `pod lib lint PLCryptography.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PLCryptography'
  s.version          = '0.0.1'
  s.summary          = 'Module for cryptography'
  s.swift_version    = '5.0'
  s.description      = <<-DESC
    Module for cryptography
                       DESC

  s.homepage         = 'https://github.com/santander-group-europe'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'paweltrojan' => 'pawel.trojan@santader.pl' }
  s.source           = { :git => 'https://github.com/santander-group-europe/ios-poland.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.3'

  s.source_files = 'PLCryptography/**/*.{swift}'
  
  s.resource_bundles = {
     'PLCryptography' => ['PLCryptography/**/*{xib,xcassets}']
  }
  s.dependency 'SANLegacyLibrary'
  s.dependency 'SANPLLibrary'
  s.dependency 'SelfSignedCertificate'
  s.dependency 'Commons'
  s.dependency 'CoreFoundationLib'
end
