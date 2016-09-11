require 'json'
require 'pry'
require 'fileutils'
require_relative 'lock_manager'

class FileConnector
  include LockManager

  def initialize(name, directory)
    @file_path = directory + name.to_s + '.json'
    create_file unless if_exist
    @file = File.open(@file_path, File::RDWR)
  end

  def read
    file = File.read(@file_path)
    JSON.parse(file)
  end

  def write(hash)
    File.open(@file_path, 'w') do |f|
      f.write(hash.to_json)
    end
    read
  end

  private

  def if_exist
    File.file?(@file_path)
  end

  def create_file
    # creat directory
    dirname = File.dirname(@file_path)
    FileUtils.mkdir_p(dirname) unless File.directory?(dirname)
    # create empty json file
    File.open(@file_path, 'w') do |f|
      f.write({}.to_json)
    end
  end
end
