require 'pry'
module BaseManager
  def list
    base_directory = YAML.load_file('config.yml')['base_directory']
    databases = Dir.entries(base_directory)
    databases.delete_if { |database| database =~ /^\./ }
    databases.map { |file_name| file_name.chomp('.json') }
  end

  def drop(database)
    base_directory = YAML.load_file('config.yml')['base_directory']
    File.delete(base_directory + database + '.json')
  end
end
