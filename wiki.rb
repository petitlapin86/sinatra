require 'sinatra'
require 'uri'


def page_content(title)
  File.read("pages/#{title}.txt")
rescue Errno::ENOENT
  return nil
end

def save_content(title, content)
  File.open("pages/#{title}.txt", "w") do |file|
    file.print(content)
  end
end

def delete_content(title, content)
  File.delete("pages/#{title}.txt")
end

get("/") do
  erb :welcome
end

get "/new" do
  erb :new #renders a new erb template and looks for new file
end

get "/:title" do #setting up get request
  @title = params[:title] #instance variables
  @content = page_content(params[@title])
  erb :show #render erb template
end

#gets a page title from url parameter load content for that page and then render and html form for that content
get "/:title/edit" do
  @title = params[:title]
  @content = page_content(@title)
  erb :edit
end

post "/create" do
  save_content(params[:title], params[:content])
  redirect URI.escape("/#{params[:title]}")
end

put "/:title" do
  save_content(params[:title], params[:content])
  redirect URI.escape("/#{params[:title]}")
end

#delete page request
delete "/:title" do
  delete_content(params[:title])
  redirect "/"
end
