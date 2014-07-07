require "sinatra"
require "./lib/database"
require "./lib/contact_database"
require "./lib/user_database"

class ContactsApp < Sinatra::Base
  enable :sessions

  def initialize
    super
    @contact_database = ContactDatabase.new
    @user_database = UserDatabase.new

    jeff = @user_database.insert(username: "Jeff", password: "jeff123")
    hunter = @user_database.insert(username: "Hunter", password: "puglyfe")

    @contact_database.insert(:name => "Spencer", :email => "spen@example.com", user_id: jeff[:id])
    @contact_database.insert(:name => "Jeff D.", :email => "jd@example.com", user_id: jeff[:id])
    @contact_database.insert(:name => "Mike", :email => "mike@example.com", user_id: jeff[:id])
    @contact_database.insert(:name => "Kirsten", :email => "kirsten@example.com", user_id: hunter[:id])
  end

  get "/" do
    if session[:user_id]
      @user_hash = @user_database.find(session[:user_id])
      @user = @user_hash[:username]
      @contact_hash = @contact_database.find_for_user(session[:user_id])
    end

    erb :root, :locals => { :user => @user, :contact_hash => @contact_hash }
  end

  get "/login/" do
    erb :login, :locals => {}
  end

  post "/login/" do
    params_sym = params.inject({}) {|memo, (k,v)| memo[k.to_sym]=v;memo}
    active_user = @user_database.all.find do |hash|
      params_sym[:password] == hash[:password] && params_sym[:username] == hash[:username]
    end

    if active_user
      session[:user_id] = active_user[:id]
    end
    redirect "/"
  end

  get "/logout/" do
    session[:user_id] = nil
    redirect "/"
  end
end