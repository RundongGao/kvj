module MetaHashMethods
  def inheritage_hash_method(method, level)
    define_method(method) do |*arg, &block|
      begin
        if level == :write
          @file_connector.grab_ex_lock
        else
          @file_connector.grab_sh_lock
        end
        hash = @file_connector.read
        return_value = hash.send(method, *arg, &block)
        @file_connector.write(hash) if level == :write
        return return_value
      ensure
        @file_connector.release_lock
      end
    end
  end

  def generate_hash_functions
    methods = Hash.instance_methods - KVJ.instance_methods
    write_methods = methods.select { |method| method =~ /=|!|delete/ }
    read_only_methods = methods - write_methods
    read_only_methods.each do |method|
      inheritage_hash_method(method, :read)
    end

    write_methods.each do |method|
      inheritage_hash_method(method, :write)
    end
  end
end
