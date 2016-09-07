require_relative 'lib/file_connector'
require 'pry'

class JBase
  def initialize(name, directory = nil)
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
end
