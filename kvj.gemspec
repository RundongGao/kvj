Gem::Specification.new do |s|
  s.name        = 'kvj'
  s.version     = '0.0.91'
  s.date        = '2016-10-04'
  s.summary     = 'A supper light connectionless key-value storage database provides ACID transcations for multiple programs.'
  s.description = 'Manipulate your key-value database just like using Ruby Hash.'
  s.authors     = ['RundongGao']
  s.email       = 'asphinx423@gmail.com'
  s.files       = ['lib/kvj.rb', 'lib/base_methods.rb', 'lib/file_connector.rb', 'lib/lock_manager.rb', 'lib/meta_hash_methods.rb']
  s.homepage    = 'https://github.com/RundongGao/kvj'
  s.license = 'MIT'
  s.add_runtime_dependency 'json'
end
