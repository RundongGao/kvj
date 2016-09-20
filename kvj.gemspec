Gem::Specification.new do |s|
  s.name        = 'kvj'
  s.version     = '0.0.2'
  s.date        = '2016-09-19'
  s.summary     = 'A supper light connectionless key-value storage database.'
  s.description = 'A supper light connectionless key-value storage database provides ACID transcations for multiple programs.'
  s.authors     = ['RundongGao']
  s.email       = 'asphinx423@gmail.com'
  s.files       = ['lib/kvj.rb', 'lib/base_manager.rb', 'lib/file_connector.rb', 'lib/lock_manager.rb']
  s.homepage    = 'https://github.com/RundongGao/kvj'
  s.license = 'MIT'
  s.add_runtime_dependency 'json'
end
