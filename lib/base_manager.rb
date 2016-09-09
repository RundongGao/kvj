module BaseManager
  def list(directory = 'data')
    databases = Dir.entries(directory)
    databases.delete_if { |database| database =~ /^\./ }
    databases
  end

  def drop
  end
end
