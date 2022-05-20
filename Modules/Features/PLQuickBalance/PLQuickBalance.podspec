Pod::Spec.new do |s|
  s.name             = 'PLQuickBalance'
  s.version          = '0.1.0'
  s.summary          = 'A short description of PLQuickBalance.'
  s.description      = <<-DESC
  PLQuickBalance
                       DESC
  s.homepage         = 'https://github.com/Krzysztof-Merski/PLQuickBalance'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'santander' => 'santander@santander.pl' }
  s.source           = { :git => 'https://github.com/santander-group-europe/ios-poland.git', :tag => s.version.to_s }
  s.ios.deployment_target = '12.3'

  s.source_files = 'PLQuickBalance/**/*.{swift}'
  s.resource_bundles = {
    'PLQuickBalance' => ['PLQuickBalance/**/*{xib,xcassets,json}']
  }

  s.dependency "UI"
  s.dependency "UIOneComponents"
  s.dependency "PLCommons"
  s.dependency "SANPLLibrary"

end
