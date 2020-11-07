# Rack-App-experiment
Learning to build a complete application just by using RACK


### Step 1 \ Run basic app:
1. mkdir todo && cd todo
2. create file config.ru 
>> config.ru (the .ru stands for "rackup") is a Rack configuration file

put this code:
``` 
class Todo
  def call(env)
    [200, {"content-type" => "text/plain"}, ["Hello world!!"]]
  end
end

run Todo.new
```

3. run 'rackup'

 ### Step 2 \ Imporove code
 1. Create file in `lib/todo.rb` && copy "Todo" class there
 2. back to config.ru 
 ```
require "todo"
run Todo.new
 ```
 
 3. restart rack server `rackup -Ilib`, `-Ilib` that include lib directory.
4.  any changes inside the lib directory you have to restart rack server. to get modifeed file, but if you want take  modifeed file immediately use `Rack::Reloader` middleware 
```
require "todo"

# for reloading files if they have been modified.
# 0 mean talk changes after 0 sconde / immediately
use Rack::Reloader, 0

run Todo.new
 ```
 
### step 3 / Create HTML template:

let go to `lib/todo.rb`

Replace this long line 
```
[200, {"content-type" => "text/plain"}, ["Hello world!"]]
```
with is middleware, the will return `html` tag not `text/plain"` with to 200 status.
```
Rack::Response.new("Hello world!")
```
