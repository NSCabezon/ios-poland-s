Pod::Spec.new do |s|
  s.name             = 'PLUI'
  s.version          = '0.1.0'
  s.summary          = 'The Poland PLUI framework.'
  s.description      = <<-DESC
The Poland PLUI framework.
                       DESC

  s.homepage         = 'https://github.com/Jose C. Yebes/PLUI'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Jose C. Yebes' => 'jose.yebes@ciberexperis.es' }
  s.source           = { :git => 'https://santander-one-app.ciber.es/ios/poland.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.3'
  s.source_files = 'PLUI/**/*.{swift}'
  
  s.dependency "UI"
  s.dependency "Commons"
end
