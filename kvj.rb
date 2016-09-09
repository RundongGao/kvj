require_relative 'lib/file_connector'
require_relative 'lib/base_manager'
require 'pry'

class KVJ
  extend BaseManager

  def initialize(name, directory = 'data')
    @file_connector = FileConnector.new(name, directory)
  end

  alias connect initialize

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

  alias [] read
  alias []= write
end
