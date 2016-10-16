require_relative 'file_connector'
require_relative 'base_methods'
require_relative 'meta_hash_methods'
require 'pry'
require 'yaml'

# load config file from user defined constant of from default path
KVJ_CONFIG_PATH ||= 'config/kvj_config.yml'.freeze
KVJ_CONFIG = YAML.load_file(KVJ_CONFIG_PATH)

class KVJ
  extend BaseMethods
  extend MetaHashMethods

  # the new constructor is hidden from user
  # please use connect_or_create, create or connect instead
  def initialize(database, directory)
    @database = database
    @file_connector = FileConnector.new(database, directory)
  end

  def self.connect_or_create(database)
    directory = KVJ_CONFIG['base_directory']
    new(database, directory)
  end

  def self.create(database)
    directory = KVJ_CONFIG['base_directory']
    return new(database, directory) unless FileConnector.exist(database, directory)
    STDERR.puts "Request to initialize a new database : #{database} but alread exists. "
    false
  end

  def self.connect(database)
    directory = KVJ_CONFIG['base_directory']
    return new(database, directory) if FileConnector.exist(database, directory)
    STDERR.puts "Request to connect to database : #{database} but does not exists. "
    false
  end

  # wrapper for KVJ instance methods for file locking on read
  def self.read_action(method)
    raw_method = "raw_#{method}".to_sym  
    alias_method raw_method, method

    define_method method do |*arg, &block|
      begin
        @file_connector.grab_sh_lock
        hash = @file_connector.read
        return_value = send(raw_method, *arg, &block)
      ensure
        @file_connector.release_lock
      end
    end
  end

  # wrapper for KVJ instance methods for file locking on write
  def self.write_action(method)
    raw_method = "raw_#{method}".to_sym  
    alias_method raw_method, method

    define_method method do |*arg, &block|
      begin
        @file_connector.grab_sh_lock
        hash = @file_connector.read
        return_value = send(raw_method, *arg, &block)
      ensure
        @file_connector.release_lock
      end
    end
  end

  def load(hash)
    raise 'current kvj is not empty, please truncate it first, or use the merge method' unless @file_connector.read.empty? 
    @file_connector.write(hash)
  end
  write_action :load

  def truncate
    @file_connector.write({})
  end
  write_action :truncate

  def dump
    @file_connector.read
  end
  read_action :dump

  # create dynamic methods for all Hash object native method
  generate_hash_functions
  private_class_method :new, :inheritage_hash_method, :generate_hash_functions, :write_action, :read_action
end

binding.pry
