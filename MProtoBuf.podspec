Pod::Spec.new do |s|
  s.name             = "MProtoBuf"
  s.version          = "1.0.13"
  s.summary          = "Helper library for MCryptoLib, responsible for parsing Google Protocol Buffers structures."
  s.homepage         = "https://github.com/Mynigma/MProtoBufLib"
  s.license          = 'GPLv3'
  s.author           = { "Roman Priebe" => "roman@mynigma.org" }
  s.source           = { :git => "https://github.com/Mynigma/MProtoBufLib.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/Mynigma'

  s.ios.deployment_target = "7.0"
  s.osx.deployment_target = "10.8"

  s.ios.libraries = 'z'
  s.osx.libraries = 'z'

  s.ios.exclude_files = "MProtoBuf/Mac"
  s.osx.exclude_files = "MProtoBuf/iOS"

  s.module_name = 'MProtoBuf'
  s.header_mappings_dir = 'Pod/Classes/include'

  s.public_header_files = "Pod/Classes/Source/**/*.h"
  s.private_header_files = 'Pod/Classes/include/**/*.h', 'Pod/Classes/Generated Files/**/*.h'
  
  s.platforms = { "ios" => "7.0", "osx" => "10.8" }
  s.requires_arc = true

  s.source_files = 'Pod/Classes/Source/**/*.{h,m,mm}', 'Pod/Classes/Generated Files/**/*.{h,m,mm,cc}', 'Pod/Classes/include/**/*.{h,m,mm,cc}'
  s.resource_bundles = {
    'MProtoBuf' => ['Pod/Assets/*.png']
  }

 end
