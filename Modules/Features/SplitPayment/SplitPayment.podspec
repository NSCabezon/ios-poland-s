#
# Be sure to run `pod lib lint SplitPayment.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SplitPayment'
  s.version          = '0.1.0'
  s.summary          = 'Poland split payment implementation'

  s.description      = <<-DESC
Split Payment implementation
                       DESC

  s.homepage         = 'https://github.com/santander-group-europe'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Santander' => '189501@santander.pl' }
  s.source           = { :git => 'https://github.com/santander-group-europe/ios-poland.git', :tag => s.version.to_s }
  s.swift_version    = '5.0'

  s.ios.deployment_target = '12.3'

  s.source_files = 'SplitPayment/**/*.{swift}'
  
   s.resource_bundles = {
     'SplitPayment' => ['SplitPayment/Assets/*{xib,xcassets}']
  }

  s.dependency "UI"
  s.dependency "PLUI"
  s.dependency "SANPLLibrary"
  s.dependency "PLCommons"
  s.dependency "Operative"
  s.dependency "PLCryptography"
  s.dependency "PLCommonOperatives"
end
