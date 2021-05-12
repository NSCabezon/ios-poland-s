#
# Be sure to run `pod lib lint PLLegacyAdapter.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PLLegacyAdapter'
  s.version          = '0.1.0'
  s.summary          = 'A short description of PLLegacyAdapter.'

  s.description      = <<-DESC
  Adapters for Leagacy
                       DESC

  s.homepage         = 'https://github.com/Jose C. Yebes/PLLegacyAdapter'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Jose C. Yebes' => 'jose.yebes@ciberexperis.es' }
  s.platform         = :ios, "10.3"
  s.source           = { :git => 'https://github.com/Jose C. Yebes/PLLegacyAdapter.git', :tag => s.version.to_s }
  s.source_files     = 'PLLegacyAdapter/**/*.{swift}'
  
   s.resource_bundles = {
     'PLLegacyAdapter' => ['PLLegacyAdapter/**/*{xib,xcassets}']
   }

  s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }

  s.dependency "SANLegacyLibrary"
  s.dependency "SANPLLibrary"
end
