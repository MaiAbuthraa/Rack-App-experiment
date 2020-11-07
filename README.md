# Rack-App-experiment
Learning to build a complete application just by using RACK


Run basic app:
1. mkdir todo && cd todo
2. create file config.ru 
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

