require "sinatra"
require "sinatra/reloader"
enable :method_override

get '/' do
  @memos = Dir.glob("*", base: "memo")
  erb:index
end

get '/new' do
  erb:new
end

post '/create' do
  @title = params[:title]
  @text = params[:text]
  File.open("./memo/#{@title}", 'wb') { |f| f.print @text}
  redirect "/"
end

get '/:title' do
  @title = params[:title]
  @text = File.open("./memo/#{@title}").read
  erb:show
end