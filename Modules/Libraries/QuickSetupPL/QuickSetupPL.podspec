Pod::Spec.new do |spec|
  spec.name         = "QuickSetupPL"
  spec.version      = "0.0.1"
  spec.summary      = "A short description of QuickSetupPL."
  spec.swift_version  = "5.0"
  spec.description  = <<-DESC
  The QuickSetup framework
                   DESC

  spec.homepage     = "http://EXAMPLE/QuickSetupPL"
  spec.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  spec.author             = { "JCEstela" => "jose.carlos.estela@ciberexperis.es" }
  spec.platform     = :ios, "10.3"
  spec.source       = { :git => "http://gitlab/QuickSetupPL.git", :tag => "#{spec.version}" }
  spec.source_files  = "QuickSetupPL", "QuickSetupPL/**/*.{swift}"
  spec.resources = "QuickSetupPL/Assets/**/*.{json,xml}"

  spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  spec.dependency "QuickSetup/standard"
  spec.dependency "SANPLLibrary"
  spec.dependency "DomainCommon"
  spec.dependency "DataRepository"
  spec.dependency "Localization"
  spec.dependency "Models"
  spec.dependency "Commons"
  spec.dependency "PLLegacyAdapter"
end
