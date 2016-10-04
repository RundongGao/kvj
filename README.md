# kvj
A supper light connectionless key-value storage database provides ACID transcation for multiple programs.

**__Using your key-value data just like using Ruby Hash.__**

rubygems : https://rubygems.org/gems/kvj

# Install

```gem install kvj```

Or with Bundler in your Gemfile.

```gem 'kvj'```

# Setup
Set `KVJ_CONFIG_PATH = your_path_to_KVJ_config_file`

Or by default the path is setted to `config/kvj_config.yml`

Create a `kvj_config.yml` at the path you setted and add

```base_directory: 'your_data_storage_directory/'```


# Usage
## initializing
``` require 'kvj' ```

To creata a new database:

``` kvj = KVJ.create(database_name) ```

To connect to existing database:

``` kvj = KVJ.connect(database_name)```

Notice that trying to create an existing database under your `base_directoy` or connecting to a non-existing one
will cause error message and return `false`.

or use 

``` kvj = KVJ.connect_or_create(database_name) ```

## EVERY Hash method you need

The BEST part of KVJ is you can use any methods from native Hash object from any version of Ruby you are useing.

It will behavior EXACTLY like a Hash object and only difference is all the data are preserved on disk (so won't lost) and you can have multiple programs share the data TRANSACTIONALLY!

For example if I am using Ruby 2.0.0 then in irb if I type 

``` KVJ.instance_methods ```

``` => [:rehash, :to_hash, :to_h, :to_a, :[], :fetch, :store, :default, :default_proc, :key, :index, :size, :length, :empty?, :each_value, :each_key, :each_pair, :each, :keys, :values, :values_at, :shift, :keep_if, :select, :reject, :clear, :invert, :update, :replace, :merge, :assoc, :rassoc, :flatten, :include?, :member?, :has_key?, :has_value?, :key?, :value?, :compare_by_identity, :compare_by_identity?, :entries, :sort, :sort_by, :grep, :count, :find, :detect, :find_index, :find_all, :collect, :map, :flat_map, :collect_concat, :inject, :reduce, :partition, :group_by, :first, :all?, :any?, :one?, :none?, :min, :max, :minmax, :min_by, :max_by, :minmax_by, :each_with_index, :reverse_each, :each_entry, :each_slice, :each_cons, :each_with_object, :zip, :take, :take_while, :drop, :drop_while, :cycle, :chunk, :slice_before, :lazy, :[]=, :default=, :default_proc=, :delete, :delete_if, :select!, :reject!, :merge!, :pry, :__binding__, :psych_to_yaml, :to_yaml, :to_yaml_properties, :pretty_print, :pretty_print_cycle, :pretty_print_instance_variables, :pretty_print_inspect, :to_json, :nil?, :===, :=~, :!~, :eql?, :hash, :<=>, :class, :singleton_class, :clone, :dup, :taint, :tainted?, :untaint, :untrust, :untrusted?, :trust, :freeze, :frozen?, :to_s, :inspect, :methods, :singleton_methods, :protected_methods, :private_methods, :public_methods, :instance_variables, :instance_variable_get, :instance_variable_set, :instance_variable_defined?, :remove_instance_variable, :instance_of?, :kind_of?, :is_a?, :tap, :send, :public_send, :respond_to?, :extend, :display, :method, :public_method, :define_singleton_method, :object_id, :to_enum, :enum_for, :pretty_inspect, :==, :equal?, :!, :!=, :instance_eval, :instance_exec, :__send__, :__id__] ```

For different version of Ruby you might get different instance methods. But don't worry, they all work~

## Usage Example

### read, write and delete
As said before, and KVJ instance includes all Hash instance methods.
Once you have a kvj object connected to your kvj database you can start to write and read from it.
``` kvj = KVJ.create('example') ```
``` kvj['Task_Counter'] = 1 ```

``` puts kvj['Task_Counter'] ```

``` => 1 ```

``` kvj['Task_Counter'] += 1 ```

``` puts kvj['Task_Counter'] ```

``` => 2 ```

new multiple programs can read and write to the same kvj same time with ACID transications provided by kvj.

In kvj, your key can only be type of string and value can be any of Integer, Fload, String, List or Hash.

``` auth_list = KVJ.create('auth_list') ```

``` auth_list['Tom'] = {'dev' => ['admin'], 'prod' => ['read','write'], 'Token' => '6Evp9N8mZpL\*yyr'} ```

``` auth_list['Bob'] = {'dev' => ['admin'], 'prod' => ['admin'], 'Token' => 'Px5a}e..,;SC~~<='} ```

``` auth_list['Michelle'] = {'dev' => ['read', 'write', 'delete'], 'prod' => [], 'Token' => 'Tg/!c%d7wxNu_=Kb'} ```

``` puts auth_list['Michelle']['dev'] ```

``` =>  ['read', 'write', 'delete'] ```

to delete a key-value pair:

``` auth_list.delete('Tom') ```

```puts auth_list.keys```

```=> ['Bob', 'Michelle']```

### More complicate cases
In KVJ you can use all the Hash instance native methods, including pass a block to it.

``` auth_list = KVJ.connect('auth_list') ```

``` prod_admin = auth_list.select {|person, auth| auth['prod'].include?('admin') }= ```

``` puts prod_admin ```

``` =>  {'Bob' : {'dev' => ['admin'], 'prod' => ['admin'], 'Token' => 'Px5a}e..,;SC~~<='} ```

Similar you can pass block of code to `each_pair`, `merger`, `delete_if` and etc.

### Other features

You can also list all databases you have under the `base_directory` you setted in config file:

``` puts KVJ.list ```

``` => ['auth_list', 'example'] ```

To drop a database:

``` KVJ.drop['example'] ```

``` puts KVJ.list ```

``` => ['auth_list'] ```


# Limitation

Under the hood, KVJ store your data in json and which means you keys can ONLY BE A STRONG and your value can only be one of INT, FLOAT, STRING, LIST, HASH and combinations of those.

# Feature to come
1. Add an object serializer to KVJ so more complicate objects can be stored.
2. Authentication.
3. RESTful API interface, KVJ as a web service.




