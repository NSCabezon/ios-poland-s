#
# Be sure to run `pod lib lint PLHelpCenter.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PLHelpCenter'
  s.version          = '0.1.0'
  s.summary          = 'Poland PLHelpCenter implementation'
  s.swift_version    = '5.0'
  s.description      = <<-DESC
  The PLHelpCenter framework
                       DESC

  s.homepage         = 'https://github.com/santander-group-europe'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'piotr-papierok-san' => 'piotr.papierok@santander.pl' }
  s.source           = { :git => 'https://github.com/santander-group-europe/ios-poland.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.3'
  s.source_files = 'PLHelpCenter', 'PLHelpCenter/**/*.{swift}'
  s.resource_bundles = {
    'PLHelpCenter' => ['PLHelpCenter/**/*{xib,xcassets,json}']
  }

  s.dependency "Commons"
  s.dependency "PLCommons"
  s.dependency "PLCommonOperatives"
  s.dependency "UI"
  s.dependency "PLUI"
  s.dependency "CommonUseCase"
  s.dependency "LoginCommon"
  s.dependency "CoreFoundationLib"
  s.dependency "SANPLLibrary"
  s.dependency "Kingfisher"
end
