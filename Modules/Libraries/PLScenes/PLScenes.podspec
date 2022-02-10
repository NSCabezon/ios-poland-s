Pod::Spec.new do |s|
  s.name             = 'PLScenes'
  s.version          = '0.1.0'
  s.summary          = 'The Poland PLScenes framework with reusable scenes.'
  s.description      = <<-DESC
The Poland PLScenes framework with reusable scenes.
                       DESC

  s.homepage         = 'https://github.com/santander-group-europe/ios-poland/Modules/Libraries/PLScenes'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Piotr Mielcarzewicz' => 'piotr.mielcarzewicz@santander.pl' }
  s.source           = { :git => 'https://santander-one-app.ciber.es/ios/poland.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.3'
  s.source_files = 'PLScenes/**/*.{swift}'
  
s.dependency "UI"
s.dependency "PLUI"
end
