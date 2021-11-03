Pod::Spec.new do |s|
    s.name          = 'DemoAuthenticator'
    s.version       = '1.0.0'
    s.summary       = 'DemoAuthenticator'
    s.homepage      = 'https://santander.pl'
    s.license       = { :type => 'Copyright', :text => 'Copyright 2020 Santander' }
    s.author        = { 'Santander' => 'contact@santander.pl' }
    s.platforms     = { :ios => "10.3" }
    s.source        = { :git => 'https://github.com/santander-group-europe', :tag => s.version }
    s.requires_arc  = true
    s.swift_version = '5.0'
    s.source_files  = 'Sources/DemoAuthenticator/**/*.{swift}'
end
