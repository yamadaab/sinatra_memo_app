# frozen_string_literal: true

require "sinatra"
require "sinatra/reloader"


get "/" do
  @memos = Dir.glob("*", base: "memo")
  erb :index
end

get "/new" do
  erb :new
end

post "/memo" do
  @title = params[:title]
  @text = params[:text]
  File.open("./memo/#{@title}", "wb") { |f| f.print @text }
  redirect "/"
end

get "/:title" do
  @title = params[:title]
  @text = File.open("./memo/#{@title}").read
  erb :show
end

get "/edit/:title" do
  @title = params[:title]
  @text = File.open("./memo/#{@title}").read
  erb :edit
end

patch "/:title" do
  @title = params[:title]
  @new_title = params[:new_title]
  @new_text = params[:new_text]
  File.rename("./memo/#{@title}", "./memo/#{@new_title}")
  File.open("./memo/#{@new_title}", "wb") { |f| f.print @new_text }
  redirect "/"
end

delete "/:title" do
  title = params[:title]
  File.delete("./memo/#{title}")
  redirect "/"
end
