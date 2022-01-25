Pod::Spec.new do |spec|
  spec.name         = "PLContexts"
  spec.version      = "0.0.1"
  spec.summary      = "Poland change contexts implementation"
  spec.swift_version    = '5.0'
  spec.description  = <<-DESC
  The PLContexts framework
                   DESC

  spec.homepage     = "https://github.com/santander-group-europe"
  spec.license      = { :type => 'MIT', :file => 'LICENSE' }
  spec.author       = { 'Jose C. Yebes' => 'jose.yebes@ciberexperis.es' }
  spec.platform     = :ios, "11.0"
  spec.source       = { :git => "https://github.com/santander-group-europe/ios-poland.git", :tag => "#{spec.version}" }
  spec.source_files  = "PLContexts", "PLContexts/**/*.{swift}"
  spec.ios.deployment_target = '11.0'
  
  spec.resource_bundles = {
    'PLContexts' => ['PLContexts/**/*{xib,xcassets}']
  }

  spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }

  spec.dependency "Commons"
  spec.dependency "PLCommons"
  spec.dependency "UI"
  spec.dependency "PLUI"
  spec.dependency "CommonUseCase"
  spec.dependency "LoginCommon"
  spec.dependency "CoreFoundationLib"
  spec.dependency "SANPLLibrary"
  spec.dependency "PLLegacyAdapter"
  spec.dependency 'PLCryptography'
  spec.dependency 'PLNotifications'
  spec.dependency 'Dynatrace'
end
