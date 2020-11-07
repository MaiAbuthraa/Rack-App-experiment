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

