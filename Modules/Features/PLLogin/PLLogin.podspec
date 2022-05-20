Pod::Spec.new do |spec|
  spec.name         = "PLLogin"
  spec.version      = "0.0.1"
  spec.summary      = "Poland login implementation"
  spec.swift_version    = '5.0'
  spec.description  = <<-DESC
  The PLLogin framework
                   DESC

  spec.homepage     = "https://github.com/santander-group-europe"
  spec.license      = { :type => 'MIT', :file => 'LICENSE' }
  spec.author       = { 'Jose C. Yebes' => 'jose.yebes@ciberexperis.es' }
  spec.platform     = :ios, "12.3"
  spec.source       = { :git => "https://github.com/santander-group-europe/ios-poland.git", :tag => "#{spec.version}" }
  spec.source_files  = "PLLogin", "PLLogin/**/*.{swift}"
  spec.ios.deployment_target = '12.3'
  
  spec.resource_bundles = {
    'PLLogin' => ['PLLogin/**/*{xib,xcassets}']
  }

  spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }

  spec.dependency "PLCommons"
  spec.dependency "PLCommonOperatives"
  spec.dependency "UI"
  spec.dependency "PLUI"
  spec.dependency "LoginCommon"
  spec.dependency "CoreFoundationLib"
  spec.dependency "SANPLLibrary"
  spec.dependency "PLLegacyAdapter"
  spec.dependency 'PLCryptography'
  spec.dependency 'PLNotifications'
  spec.dependency 'Dynatrace'
  spec.dependency 'PLQuickBalance'
end
