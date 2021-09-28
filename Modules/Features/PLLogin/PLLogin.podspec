Pod::Spec.new do |spec|
  spec.name         = "PLLogin"
  spec.version      = "0.0.1"
  spec.summary      = "Poland login implementation"
  spec.swift_version    = '5.0'
  spec.description  = <<-DESC
  The PLLogin framework
                   DESC

  spec.homepage     = "http://EXAMPLE/PLLogin"
  spec.license      = { :type => 'MIT', :file => 'LICENSE' }
  spec.author       = { 'Jose C. Yebes' => 'jose.yebes@ciberexperis.es' }
  spec.platform     = :ios, "11.0"
  spec.source       = { :git => "http://gitlab/PLLogin.git", :tag => "#{spec.version}" }
  spec.source_files  = "PLLogin", "PLLogin/**/*.{swift}"
  spec.ios.deployment_target = '11.0'
  
  spec.resource_bundles = {
    'PLLogin' => ['PLLogin/**/*{xib,xcassets}']
  }

  spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }

  spec.dependency "Commons"
  spec.dependency "PLCommons"
  spec.dependency "Models"
  spec.dependency "UI"
  spec.dependency "PLUI"
  spec.dependency "Repository"
  spec.dependency "CommonUseCase"
  spec.dependency "LoginCommon"
  spec.dependency "iOSPublicFiles"
  spec.dependency "SANPLLibrary"
  spec.dependency "PLLegacyAdapter"
  spec.dependency 'PLSelfSignedCertificate'
  spec.dependency 'PLNotifications'
end
