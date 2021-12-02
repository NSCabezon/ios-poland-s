Pod::Spec.new do |s|
  s.name             = 'PLUI'
  s.version          = '0.1.0'
  s.summary          = 'The Poland PLUI framework.'
  s.description      = <<-DESC
The Poland PLUI framework.
                       DESC

  s.homepage         = 'https://EXAMPLE/PLUI'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Jose C. Yebes' => 'jose.yebes@ciberexperis.es' }
  s.source           = { :git => 'https://santander-one-app.ciber.es/ios/poland.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'
  s.source_files = "PLUI/**/*.{swift}"
  s.resources = "PLUI/**/*.{xcassets}"
  s.resource_bundles = {
    'PLUI' => ['PLUI/**/*.{storyboard,ttf,json,strings,xib,m4a,caf}']
  }
  s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }

  s.dependency "UI"

end
