require "erb"

class Todo
  def call(env)
    # Rack::Request, which also provides query string parsing and multipart handling.
    request = Rack::Request.new(env)

    case request.path
    when '/' then Rack::Response.new(render("index.html.erb"))
    else Rack::Response.new("Not Found", 404)
    end
    # Rack::Response, for convenient generation of HTTP replies and cookie handling.
  end

  def render(template)
    path = File.expand_path("../../views/#{template}", __FILE__)
    ERB.new(File.read(path)).result(binding)
  end
end

