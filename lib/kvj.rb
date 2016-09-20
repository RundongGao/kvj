require_relative 'file_connector'
require_relative 'base_manager'
require 'pry'
require 'yaml'

CONFIG = YAML.load_file('config/kvj_config.yml')

class KVJ
  extend BaseManager

  def self.create(database)
    directory = CONFIG['base_directory']
    return new(database, directory) unless FileConnector.exist(database, directory)
    STDERR.puts "Request to initialize a new database : #{database} but alread exists. "
    false
  end

  def self.connect(database)
    directory = CONFIG['base_directory']
    return new(database, directory) if FileConnector.exist(database, directory)
    STDERR.puts "Request to connect to database : #{database} but does not exists. "
    false
  end

  def write(key, value)
    @file_connector.grab_ex_lock
    hash = @file_connector.read
    hash[key] = value
    @file_connector.write(hash)
    return true
  ensure
    @file_connector.release_lock
  end

  def read(key)
    @file_connector.grab_sh_lock
    data = @file_connector.read
    return false unless key_exist(data, key, 'read')
    return data[key]
  ensure
    @file_connector.release_lock
  end

  def inspect_keys
    @file_connector.grab_sh_lock
    @file_connector.read.keys
  ensure
    @file_connector.release_lock
  end

  def delete(key)
    @file_connector.grab_ex_lock
    data = @file_connector.read
    return false unless key_exist(data, key, 'delete')
    data.delete(key)
    @file_connector.write(hash)
  ensure
    @file_connector.release_lock
  end

  alias []= write
  alias [] read

  def key_exist(data, key, action)
    return true if data.key?(key)
    STDERR.puts "Request to #{action} key : '#{key}' does not exist in database : '#{@database}' "
    false
  end

  def initialize(database, directory)
    @database = database
    @file_connector = FileConnector.new(database, directory)
  end

  private :key_exist
  private_class_method :new
end
