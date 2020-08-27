require "sinatra"
require "sinatra/reloader"
enable :method_override

get '/' do
  @memos = Dir.glob("*", base: "memo")
  erb:index
end
