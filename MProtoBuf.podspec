Pod::Spec.new do |s|
  s.name             = "MProtoBuf"
  s.version          = "1.0.0"
  s.summary          = "Helper library for MCryptoLib, responsible for parsing Google Protocol Buffers structures."
  s.homepage         = "https://github.com/Mynigma/MProtoBufLib"
  s.license          = 'GPLv3'
  s.author           = { "Roman Priebe" => "roman@mynigma.org" }
  s.source           = { :git => "https://github.com/Mynigma/MProtoBuf.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/Mynigma'

  s.ios.deployment_target = "7.0"
  s.osx.deployment_target = "10.8"

  s.ios.libraries = 'z'

  s.header_dir = 'MProtoBuf'

  s.platforms = { "ios" => "7.0", "osx" => "10.8" }
  s.requires_arc = true

  s.source_files = 'Pod/Classes/Source/**/*.{h,m}', 'Pod/Classes/Generated Files/**/*.{h,m}', '../Example/include/**/*.{h,m}'
  s.resource_bundles = {
    'MProtoBuf' => ['Pod/Assets/*.png']
  }

 end
