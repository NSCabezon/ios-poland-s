#
# Be sure to run `pod lib lint PLCommonOperatives.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PLCommonOperatives'
  s.version          = '0.0.1'
  s.summary          = 'Module for common usceCases and operatives'
  s.swift_version    = '5.0'
  s.description      = <<-DESC
  Module for common usceCases and operatives
                       DESC

  s.homepage         = 'https://github.com/santander-group-europe'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'mateniec' => 'mateusz.niec@santander.pl' }
  s.source           = { :git => 'https://github.com/santander-group-europe/ios-poland.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.3'

  s.source_files = 'PLCommonOperatives/**/*.{swift}'
  
  s.resource_bundles = {
     'PLCommonOperatives' => ['PLCommonOperatives/**/*{xib,xcassets}']
  }

  s.dependency "SANPLLibrary"
  s.dependency "PLCommons"
end
