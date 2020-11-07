require "todo"

# for reloading files if they have been modified.
# 0 mean talk changes after 0 sconde / immediately
use Rack::Reloader, 0

# Rack::Cascade, for trying additional Rack applications if an application returns a not found or method not supported response.
# Rack::Files, for serving static files.
run Rack::Cascade.new([Rack::File.new('public'), Todo])
