require "todo"

# for reloading files if they have been modified.
# 0 mean talk changes after 0 sconde / immediately
use Rack::Reloader, 0

run Todo
