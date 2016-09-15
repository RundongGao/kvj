Gem::Specification.new do |s|
  s.name        = 'kvj'
  s.version     = '0.0.1'
  s.date        = '2016-09-11'
  s.summary     = "A supper light weight value data database."
  s.description = "a supper light key value storage database in json file provides ACID transcation on disk for multiple programs."
  s.authors     = ["Rundong Gao"]
  s.email       = 'asphinx423@gmail.com'
  s.files       = ["lib/kvj.rb", 'lib/base_manager.rb', 'lib/file_connector.rb', 'lib/lock_manager.rb']
  s.homepage    =
    'http://rubygems.org/gems/hola'
  s.license       = 'MIT'
end