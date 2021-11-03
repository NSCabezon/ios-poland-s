#
# Be sure to run `pod lib lint BLIK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'BLIK'
  s.version          = '0.0.1'
  s.summary          = 'Poland BLIK implementation'
  s.swift_version    = '5.0'
  s.description      = <<-DESC
  The BLIK framework
                       DESC

  s.homepage         = 'https://github.com/santander-group-europe'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'agnieszka.szczurek' => 'agnieszka.szczurek@santander.pl' }
  s.source           = { :git => 'https://github.com/santander-group-europe/ios-poland.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.3'

  s.source_files = 'BLIK/**/*.{swift}'

  s.resource_bundles = {
    'BLIK' => ['BLIK/**/*{xib,xcassets}']
  }

  s.dependency "UI"
  s.dependency "PLUI"
  s.dependency "SANPLLibrary"
  s.dependency "PLCommons"
  s.dependency "Operative"
  s.dependency "PLCommonOperatives"
end
