#
# Be sure to run `pod lib lint LoanSchedule.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LoanSchedule'
  s.version          = '0.1.0'
  s.summary          = 'Poland LoanSchedule implementation'
  s.swift_version    = '5.0'
  s.description      = <<-DESC
  The LoanSchedule framework
                       DESC

  s.homepage         = 'https://github.com/santander-group-europe'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'pawel-klosowicz-san' => 'Pawel.Klosowicz@santander.pl' }
  s.source           = { :git => 'https://github.com/santander-group-europe/ios-poland.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.3'
  s.source_files = 'LoanSchedule', 'LoanSchedule/**/*.{swift}'
  s.resource_bundles = {
    'LoanSchedule' => ['LoanSchedule/**/*{xib,xcassets,json}']
  }

  s.dependency "Commons"
  s.dependency "PLCommons"
  s.dependency "Models"
  s.dependency "UI"
  s.dependency "PLUI"
  s.dependency "Repository"
  s.dependency "CommonUseCase"
  s.dependency "LoginCommon"
  s.dependency "CoreFoundationLib"
  s.dependency "SANPLLibrary"
end
