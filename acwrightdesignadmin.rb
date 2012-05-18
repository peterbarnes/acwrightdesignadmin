require File.dirname(__FILE__) + '/bootstrap.rb'

class Acwrightdesignadmin < Sinatra::Base
  
  use Rack::Session::Cookie
  
  configure do
    set :sessions,        true
    set :session_secret,  ENV['SESSION_KEY'] ||= 'secret'
    set :root,            File.dirname(__FILE__)
    set :views,           File.join(Sinatra::Application.root, 'views')
    set :haml,            { :format => :html5, :layout => :'acwrightdesignadmin' }
  end
  
  helpers do
    
    def user
      @current_user ||= User.first(:username => Base64.decode64(session[:user])) if session[:user]
    end
      
    def authenticate!
      unless user
        redirect '/login'
      end
    end
    
  end

  get '/' do
    if user
      redirect '/creations'
    else
      redirect '/login'
    end
  end
  
  # Auth
  
  get '/login' do
    haml :'auth/login'
  end
  
  post '/login/?' do
    @user = User.first(:username => params[:username])
    if @user
      if @user.password_hash == BCrypt::Engine.hash_secret(params[:password], @user.password_salt)
      session[:user] = Base64.encode64(@user.username).strip
      redirect '/creations'
      else
        redirect '/login'
      end
    else
      redirect '/login'
    end
  end
  
  get '/logout' do
    session[:user] = nil
    redirect '/login'
  end
  
  # Creations
  
  before '/creations/?*' do
    authenticate!
  end
  
  get '/creations/?' do
    @creations = Creation.where(:active => true).sort(:name)
    haml :'creations/index'
  end
  
  post '/creations/?' do
    @creation = Creation.new
    
    unless @creation.nil?
      @creation.name = params[:name]
      @creation.thumbnail = params[:thumbnail]
      @creation.description = params[:description]

      if @creation.save
        redirect '/creations'
      else
        haml :'creations/edit'
      end
    else
      redirect '/creations/create'
    end
  end
  
  post '/creations/:id/?' do
    @creation = Creation.find(params[:id])
    
    unless @creation.nil?
      @creation.name = params[:name]
      @creation.thumbnail = params[:thumbnail]
      @creation.description = params[:description]

      if @creation.save
        redirect '/creations'
      else
        haml :'creations/edit'
      end
    else
      redirect "/creations/#{params[:id]}/edit"
    end
  end
  
  get '/creations/create/?' do
    haml :'creations/edit'
  end
  
  get '/creations/:id/edit/?' do
    @creation = Creation.find(params[:id])
    haml :'creations/edit'
  end
  
  get '/creations/:id/delete/?' do
    @creation = Creation.find(params[:id])
    
    unless @creation.nil?
      @creation.active = false
      @creation.save
    end
    
    redirect '/creations'
  end
  
  # Contacts
  
  before '/contacts/?*' do
    authenticate!
  end
  
  get '/contacts/?' do
    @contacts = Contact.where(:active => true).sort(:created_at)
    haml :'contacts/index'
  end
  
  get '/contacts/:id/view/?' do
    @contact = Contact.find(params[:id])
    haml :'contacts/view'
  end
  
  get '/contacts/:id/delete/?' do
    @contact = Contact.find(params[:id])
    
    unless @contact.nil?
      @contact.active = false
      @contact.save
    end
    
    redirect '/contacts'
  end
  
  # URLS
  
  before '/urls/?*' do
    authenticate!
  end
  
  get '/urls/?' do
    @urls = Url.where(:active => true).sort(:name).all.sort! do |a,b|
      unless a.creation.nil? || b.creation.nil? 
        a.creation.name <=> b.creation.name
      else
        a.name <=> b.name
      end
    end
    haml :'urls/index'
  end
  
  post '/urls/?' do
    @url = Url.new
    
    unless @url.nil?
      @url.name = params[:name]
      @url.url = params[:url]
      @url.creation_id = params[:creation_id]

      if @url.save
        redirect '/urls'
      else
        haml :'urls/edit'
      end
    else
      redirect '/urls/create'
    end
  end
  
  post '/urls/:id/?' do
    @url = Url.find(params[:id])
    
    unless @url.nil?
      @url.name = params[:name]
      @url.url = params[:url]
      @url.creation_id = params[:creation_id]

      if @url.save
        redirect '/urls'
      else
        haml :'urls/edit'
      end
    else
      redirect "/urls/#{params[:id]}/edit"
    end
  end
  
  get '/urls/create/?' do
    haml :'urls/edit'
  end
  
  get '/urls/:id/edit/?' do
    @url = Url.find(params[:id])
    haml :'urls/edit'
  end
  
  get '/urls/:id/delete/?' do
    @url = Url.find(params[:id])
    
    unless @url.nil?
      @url.active = false
      @url.save
    end
    
    redirect '/urls'
  end
  
  # Users
  
  before '/users/?*' do
    authenticate!
  end
  
  get '/users/?' do
    @users = User.where(:active => true).sort(:username)
    haml :'users/index'
  end
  
  post '/users/?' do
    @user = User.new
    
    unless @user.nil?
      @user.username = params[:username]
      @user.first_name = params[:first_name]
      @user.last_name = params[:last_name]
      @user.password = params[:password]
      @user.password_confirmation = params[:password_confirmation]

      if @user.save
        redirect '/users'
      else
        haml :'users/edit'
      end
    else
      redirect '/users/create'
    end
  end
  
  post '/users/:id/?' do
    @user = User.find(params[:id])
    
    unless @user.nil?
      @user.username = params[:username]
      @user.first_name = params[:first_name]
      @user.last_name = params[:last_name]

      unless params[:password].nil? || params[:password_confirmation].nil?
        @user.password = params[:password]
        @user.password_confirmation = params[:password_confirmation]
      end

      if @user.save
        redirect '/users'
      else
        haml :'users/edit'
      end
    else
      redirect "/users/#{params[:id]}/edit"
    end
  end
  
  get '/users/create/?' do
    haml :'users/edit'
  end
  
  get '/users/:id/edit/?' do
    @user = User.find(params[:id])
    haml :'users/edit'
  end
  
  get '/users/:id/delete/?' do
    @user = User.find(params[:id])
    
    unless @user.nil?
      @user.username = nil
      @user.active = false
      @user.save
    end
    
    redirect '/users'
  end
  
  get '/*' do
    redirect '/'
  end
  
end