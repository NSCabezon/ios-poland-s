#
# Be sure to run `pod lib lint Authorization.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = 'Authorization'
    s.version          = '0.1.0'
    s.summary          = 'Module for user authentication and authorization'
    s.swift_version    = '5.0'

    s.description      = <<-DESC
    The Authentication and Authorization framework
                       DESC

    s.homepage         = 'https://github.com/Patryk Grabowski/Authorization'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Patryk Grabowski' => 'pagb@ailleron.com' }
    s.source           = { :git => 'https://github.com/santander-group-europe/ios-poland.git', :tag => s.version.to_s }

    s.ios.deployment_target = '12.3'
    s.source_files = 'Authorization/**/*.{swift}'

    s.resource_bundles = {
     'Authorization' => ['Authorization/Assets/*.png']
    }

    s.dependency "UI"
    s.dependency "PLUI"
    s.dependency "SANPLLibrary"
    s.dependency "PLCommons"
    s.dependency "Operative"
    s.dependency "PLCryptography"
    s.dependency "PLCommonOperatives"
end
