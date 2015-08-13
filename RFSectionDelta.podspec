Pod::Spec.new do |s|
  s.name = 'RFSectionDelta'
  s.version = '1.0.0'
  s.license = 'MIT'
  s.summary = 'Transform data changes into table view and collectionview updates'
  s.homepage = 'https://github.com/ryanfitz/RFSectionDelta'
  s.social_media_url = 'http://twitter.com/theRyanFitz'
  s.authors = { 'Ryan Fitzgerald' => 'ryan.fitz1@gmail.com' }
  s.source = { :git => 'https://github.com/ryanfitz/RFSectionDelta.git', :tag => s.version }
  s.ios.deployment_target = '8.0'
  s.source_files = 'RFSectionDelta/**/*.swift'
  s.requires_arc = true
end
