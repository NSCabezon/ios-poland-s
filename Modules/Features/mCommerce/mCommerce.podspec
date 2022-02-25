#
# Be sure to run `pod lib lint mCommerce.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'mCommerce'
  s.version          = '0.1.0'
  s.summary          = 'Poland mCommerce implementation'
  s.swift_version    = '5.0'
  s.description      = <<-DESC
  The LoanSchedule framework
                       DESC

  s.homepage         = 'https://github.com/santander-group-europe'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'vasyl-skop-san' => 'vasyl.skop@santander.pl' }
  s.source           = { :git => 'https://github.com/santander-group-europe/ios-poland.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.3'
  s.source_files = 'mCommerce', 'mCommerce/**/*.{swift}'
  s.resource_bundles = {
    'mCommerce' => ['mCommerce/**/*{xib,xcassets}']
  }

  s.dependency "UI"
  s.dependency "PLUI"
  s.dependency "PLCommons"
  s.dependency "LoginCommon"
  s.dependency "SANPLLibrary"
  s.dependency "CoreFoundationLib"
end
