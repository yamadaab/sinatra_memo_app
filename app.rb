# frozen_string_literal: true

require "sinatra"
require "sinatra/reloader"
require "pg"

get "/" do
  begin
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
      title = params[:title]
      text = params[:text]
      connection.exec(
        "INSERT INTO Memos (title, memo) VALUES ($1, $2);", [title, text],
      )
      ensure
        connection.close if connection
    end
  redirect "/"
end

get "/:id" do
  id= params[:id]
  begin
    @result = connection.exec("SELECT * FROM Memos WHERE id = $1;", [id])
  ensure
    connection.close if connection
  end
  erb :show
end

get "/edit/:id" do
  id= params[:id]
  begin
    @result = connection.exec("SELECT * FROM Memos WHERE id = $1;", [id])
  ensure
    connection.close if connection
  end
  erb :edit
end

patch "/:id" do
  id= params[:id]
  begin
    new_title = params[:new_title]
    new_memo = params[:new_memo]
    connection.exec("UPDATE Memos SET title = $1, memo = $2 WHERE id = $3;", [new_title, new_memo, id])
  ensure
    connection.close if connection
  end
  redirect "/"
end

delete "/:id" do
  id = params[:id]
  begin
    connection.exec("DELETE FROM Memos WHERE id = $1;", [id])
  ensure
    connection.close if connection
  end
  redirect "/"
end

def connection
  PG.connect(host: "localhost", user: "yamadashingo", password: "password", dbname: "postgres")
end
