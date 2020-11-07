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
 
### step 3 / use Rack::Response

let's go to `lib/todo.rb`

Replace this long line 
```
[200, {"content-type" => "text/plain"}, ["Hello world!"]]
```
with this  middleware, that will return `html` tag not `text/plain"` with to 200 status.
```
Rack::Response.new("Hello world!")
```

### step 4 / Create HTML template (erb):
1. update `lib/todo.rb`

```
require "erb"

class Todo
  def call(env)
    Rack::Response.new(render("index.html.erb"))
  end

  def render(template)
    path = File.expand_path("../../views/#{template}", __FILE__)
    ERB.new(File.read(path)).result(binding)
  end
end
```

2. then create the template `/todo/views/index.html.erb`
```
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN">
<html>
  <head>
    <title>My first rake app</title>
    <style type="text/css">
    body {
      color: purple;
      background-color: #d8da3d }
    </style>
  </head>

  <body>
    <h1>Hello World!!</h1>
  </body>
</html>
```

### step 5 / Build basic routes:
inside call method `lib/todo.rb`

```
# Rack::Request, which also provides query string parsing and multipart handling.
request = Rack::Request.new(env)

case request.path
when '/' then Rack::Response.new(render("index.html.erb"))
else Rack::Response.new("Not Found", 404)
end
```


### step 6 / Submit Form:

`todo/lib/todo.rb`

```
require "erb"

class Todo
  def call(env)
    # Rack::Request, which also provides query string parsing and multipart handling.
    @request = Rack::Request.new(env)

    case @request.path
    when '/' then Rack::Response.new(render("index.html.erb"))
    when '/create'
      Rack::Response.new do |response|
        response.set_cookie('task', @request.params['task'])

        response.redirect("/")
      end
    else Rack::Response.new("Not Found", 404)
    end
    # Rack::Response, for convenient generation of HTTP replies and cookie handling.
  end

  def render(template)
    path = File.expand_path("../../views/#{template}", __FILE__)
    ERB.new(File.read(path)).result(binding)
  end

  def task
    @request.cookies['task'] || "No task"
  end
end

```

`todi/views/index.html.erb` inside body tag
```
<%= task %>
```

 ### step 7 / Make sure the instance variable will persist between requests:


`todo/config.ru`

```
require "todo"

use Rack::Reloader, 0

run Todo
```

`todo/lib/todo.rb`

```
require "erb"

class Todo
  def self.call(env)
    new(env).responses.finish
  end

  def initialize(env)
    # Rack::Request, which also provides query string parsing and multipart handling.
    @request = Rack::Request.new(env)
  end

  def responses
    case @request.path
    when '/' then Rack::Response.new(render("index.html.erb"))
    when '/create'
      Rack::Response.new do |response|
        response.set_cookie('task', @request.params['task'])

        response.redirect("/")
      end
    else Rack::Response.new("Not Found", 404)
    end
    # Rack::Response, for convenient generation of HTTP replies and cookie handling.
  end

  def render(template)
    path = File.expand_path("../../views/#{template}", __FILE__)
    ERB.new(File.read(path)).result(binding)
  end

  def task
    @request.cookies['task'] || "No task"
  end
end

```

then restart rake server
