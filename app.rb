# frozen_string_literal: true

require "sinatra"
require "sinatra/reloader"
require "pg"

get "/" do
  @result = connection(sql: "SELECT * FROM Memos")
  erb :index
end

get "/new" do
  erb :new
end

post "/memo" do
  title = params[:title]
  memo = params[:memo]
  redirect "/new" if title.empty? && memo.empty?
  connection(sql: "INSERT INTO Memos (title, memo) VALUES ($1, $2);", key: [title, memo]) if !title.empty? && !memo.empty?
  redirect "/"
end

get "/:id" do
  id= params[:id]
  @result = connection(sql: "SELECT * FROM Memos WHERE id = $1;", key: [id])
  erb :show
end

get "/edit/:id" do
  id= params[:id]
  @result = connection(sql: "SELECT * FROM Memos WHERE id = $1;", key: [id])
  erb :edit
end

patch "/:id" do
  id= params[:id]
  new_title = params[:new_title]
  new_memo = params[:new_memo]
  redirect "/edit/#{id}" if new_title.empty? && new_memo.empty?
  connection(sql: "UPDATE Memos SET  memo = $1 WHERE id = $2;", key: [new_memo, id]) if new_title.empty?
  connection(sql: "UPDATE Memos SET  title = $1 WHERE id = $2;", key: [new_title, id]) if new_memo.empty?
  connection(sql: "UPDATE Memos SET title = $1, memo = $2 WHERE id = $3;", key: [new_title, new_memo, id]) if !new_title.empty? && !new_memo.empty?
  redirect "/"
end

delete "/:id" do
  id = params[:id]
  connection(sql: "DELETE FROM Memos WHERE id = $1;", key: [id])
  redirect "/"
end

def connection(sql:, key: [])
  connect = PG.connect(host: "localhost", user: "yamadashingo", password: "password", dbname: "postgres")
  begin
    connect.exec(sql, key)
  ensure
    connect.close if connect
  end
end
