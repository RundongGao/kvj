# kvj
A supper light connectionless key-value storage database provides ACID transcation for multiple programs.

rubygems : https://rubygems.org/gems/kvj

# Install

```gem install kvj```

Or with Bundler in your Gemfile.

```gem 'kvj', :require => false```

# Setup
Create a `config/kvj_config.yml` file on root directory of your project.

And add

```base_directory: 'your_data_storage_directory/'```

to the file you created.

# Usage
## initializing
``` require 'kvj' ```

``` kvj = KVJ.new(database_name) ```

or

``` kvj = KVJ.connect(database_name)```

This will connect to your database or create a new one if the 'database_name' doesn't exist.

## read and write to kvj
Once you have a kvj object connected to your kvj database you can start to write and read from it.

``` kvj['Task_Counter'] = 1 ```

``` puts kvj['Task_Counter'] ```

``` => 1 ```

``` kvj['Task_Counter'] += 1 ```

``` puts kvj['Task_Counter'] ```

``` => 2 ```

multiple programs can read and write to the same kvj same time with ACID transications provided by kvj as long as their kvj are configed to the `base_directory`.

In kvj, your key can only be type of string and value can be any of Integer, Fload, String, List or Hash.

``` auth_list = KVJ.new('auth_list') ```

``` auth_list['Tom'] = {'dev' => ['admin'], 'prod' => ['read','write'], 'Token' => '6Evp9N8mZpL\*yyr'} ```

``` auth_list['Bob'] = {'dev' => ['admin'], 'prod' => ['admin'], 'Token' => 'Px5a}e..,;SC~~<='} ```

``` auth_list['Michelle'] = {'dev' => ['read', 'write', 'delete'], 'prod' => [], 'Token' => 'Tg/!c%d7wxNu_=Kb'} ```

``` puts auth_list['Michelle']['dev'] ```

``` =>  ['read', 'write', 'delete'] ```

# List all keys:
to view all the keys you have in your database

```puts auth_list.inspect_keys```

```=>  ['Tom', 'Bob', 'Michelle'] ```


# Delete a key:
to delete a key-value pair:

``` auth_list.delete('Tom') ```

```puts auth_list.inspect_keys```

```=> ['Bob', 'Michelle']```



# Other feature

You can also list all databases you have under the `base_directory` you set in config file:

``` puts KVJ.list ```

``` => ['auth_list', 'test'] ```

and drop a database:

``` KVJ.drop['test'] ```

``` puts KVJ.list ```

``` => ['auth_list'] ```

# Features to come
Inheritage methods from Hash class by method missing and also type checks ( only objects that can  be writen to json are allowed )
Error handling and error message



