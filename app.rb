# frozen_string_literal: true

require "sinatra"
require "sinatra/reloader"
require 'pg'

get "/" do
  begin
    settings = { host: 'localhost', user: 'yamadashingo', password: 'password', dbname: 'postgres' }  
    connection = PG::connect(settings)  

    @result = connection.exec("SELECT * FROM Memos")
    ensure
      connection.close if connection
    end
  erb :index
end

get "/new" do
  erb :new
end

post "/memo" do
  begin
    settings = { host: 'localhost', user: 'yamadashingo', password: 'password', dbname: 'postgres' }  
    connection = PG::connect(settings)  

    title = params[:title]
    text = params[:text]
    connection.exec(
      'INSERT INTO Memos (title, memo) VALUES ($1, $2);',  
      [title, text],
    )
    ensure  
      connection.close if connection
    end  
  redirect "/"
end

get "/:id" do
  id= params[:id]
  begin
    settings = { host: 'localhost', user: 'yamadashingo', password: 'password', dbname: 'postgres' }  
    connection = PG::connect(settings)  
    @result = connection.exec("SELECT * FROM Memos WHERE id='#{id}'")
  ensure
    connection.close if connection
  end
  erb :show
end

get "/edit/:id" do
  id= params[:id]
  begin
    settings = { host: 'localhost', user: 'yamadashingo', password: 'password', dbname: 'postgres' }  
    connection = PG::connect(settings)  
    @result = connection.exec("SELECT * FROM Memos WHERE id='#{id}';")
  ensure
    connection.close if connection
  end
  erb :edit
end

patch "/:id" do
  id= params[:id]
  begin
    settings = { host: 'localhost', user: 'yamadashingo', password: 'password', dbname: 'postgres' }  
    connection = PG::connect(settings)  
    new_title = params[:new_title]
    new_memo = params[:new_memo]
    result = connection.exec("UPDATE Memos SET title = '#{new_title}', memo = '#{new_memo}' WHERE id='#{id}';")
  ensure
    connection.close if connection
  end
  redirect "/"
end

delete "/:id" do
  id = params[:id]
  begin
    settings = { host: 'localhost', user: 'yamadashingo', password: 'password', dbname: 'postgres' }  
    connection = PG::connect(settings)  
    result = connection.exec("DELETE FROM Memos WHERE id='#{id}';")
  ensure
    connection.close if connection
  end
  redirect "/"
end
