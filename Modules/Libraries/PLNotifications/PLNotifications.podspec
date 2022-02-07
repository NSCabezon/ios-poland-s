#
# Be sure to run `pod lib lint PLNotifications.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PLNotifications'
  s.version          = '0.0.1'
  s.summary          = 'PLNotifications is a library to isolate notifications'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/Israel Marcos Álvarez Mesa/PLNotifications'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Israel Marcos Álvarez Mesa' => 'marcos.alvarez@experis.es' }
  s.source           = { :git => 'https://github.com/Israel Marcos Álvarez Mesa/PLNotifications.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'

  s.source_files = 'PLNotifications/**/*'
  
  # s.resource_bundles = {
  #   'PLNotifications' => ['PLNotifications/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/**/*.h'
#  s.static_framework = true
  s.dependency 'Firebase/Messaging', '~> 8.8.0'
  s.dependency 'Firebase', '~> 8.8.0'
  s.dependency "CoreFoundationLib"
  s.dependency "CorePushNotificationsService"
end
