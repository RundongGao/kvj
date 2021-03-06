require 'json'
require 'pry'
require 'fileutils'
require_relative 'lock_manager'

class FileConnector
  include LockManager

  def initialize(name, directory)
    @file_path = directory + name.to_s + '.json'
    create_file unless FileConnector.exist(name, directory)
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

  def self.exist(name, directory)
    file_path = directory + name.to_s + '.json'
    File.file?(file_path)
  end

  private

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
