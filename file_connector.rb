require 'json'
require 'pry'
require 'fileutils'

# this version does not have any locks
# figure out locks later
class FileConnector
  def initialize(name, directory = nil)
    @file_path = directory.to_s + name.to_s + '.json'
  end

  def read
    return unless if_exist
    file = File.read(@file_path)
    JSON.parse(file)
  end

  def write(hash)
    create_directory unless if_exist
    File.open(@file_path, 'w') do |f|
      f.write(hash.to_json)
    end
    read
  end

  private

  def if_exist
    File.file?(@file_path)
  end

  def create_directory
    dirname = File.dirname(@file_path)
    FileUtils.mkdir_p(dirname) unless File.directory?(dirname)
  end
end
