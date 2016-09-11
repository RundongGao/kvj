require_relative 'lib/file_connector'
require_relative 'lib/base_manager'
require 'pry'
require 'yaml'

class KVJ
  extend BaseManager

  def initialize(name)
    directory = YAML.load_file('config.yml')['base_directory']
    @file_connector = FileConnector.new(name, directory)
  end

  def write(key, value)
    @file_connector.grab_ex_lock
    hash = @file_connector.read
    hash[key] = value
    @file_connector.write(hash)
  ensure
    @file_connector.release_lock
  end

  def read(key)
    @file_connector.grab_sh_lock
    @file_connector.read[key]
  ensure
    @file_connector.release_lock
  end

  def inspect_keys
    @file_connector.grab_sh_lock
    @file_connector.read.keys
  ensure
    @file_connector.release_lock
  end

  class << self
    alias connect new
  end
  alias []= write
  alias [] read
end
