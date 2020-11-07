class Todo
  def call(env)
    Rack::Response.new("Hello world!")
  end
end

