# kvj
a supper light key value storage database in json file provides ACID transcation on disk for multiple programs.

*kvj has not been realeased as a gem yet, since it is still in developing.*

# Usage
## initializing
``` include 'path_to_kvj_project/jbase.rb' ```

``` kvj = JBase.new(database_name) ```

## read value from a key
``` kvj = JBase.new(database_name) ```

``` value = kvj.read('YOUR_KEY') ```

## write value to a key
``` kvj = JBase.new(database_name) ```

``` kvj.write('YOUR_KEY', 'YOUR_VALUE') ```


