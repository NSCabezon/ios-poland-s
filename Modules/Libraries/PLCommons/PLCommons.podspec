Pod::Spec.new do |s|
  s.name             = 'PLCommons'
  s.version          = '0.1.0'
  s.summary          = 'A short description of PLCommons.'
  s.description      = <<-DESC
The Poland PLCommons framework.
                       DESC

  s.homepage         = 'https://github.com/Jose C. Yebes/PLCommons'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Jose C. Yebes' => 'jose.yebes@ciberexperis.es' }
  s.source           = { :git => 'https://github.com/Jose C. Yebes/PLCommons.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.3'

  s.source_files = 'PLCommons/**/*.{swift}'
  
s.dependency "Commons"
s.dependency "Helpers"
end
