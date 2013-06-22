# encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'data_mapper' 

DataMapper.setup(:default, "sqlite3:db.sqlite3")

class User
  include DataMapper::Resource

  property :id,       Serial
  property :name,     String
  property :email,	  String	
  property :login,    String
  property :password, String

  has n, :posts
end

class Post
	include DataMapper::Resource

	property :id,    	  Serial
	property :title,      String
	property :text,  	  Text
	property :created_at, DateTime

	belongs_to :user
	has n, :comment
end

class Comment
	include DataMapper::Resource

	property :id,    	  Serial
	property :text,  	  Text
	property :created_at, DateTime

	belongs_to :user
	belongs_to :post
end

DataMapper.finalize
DataMapper.auto_upgrade!

enable :sessions

get '/' do
	@posts = Post.all
  	erb :home
end

get '/sign_up' do
	erb :new_user
end

post '/sign_in' do
	if params[:login].empty? and params[:password].empty?
		session[:error] = "Empty"
		redirect back
	end

	user = User.first(:login => params[:login], :password => params[:password])
	if user != nil
		session[:user] = user
	else
		session[:error] = "Incorect password or login"	
	end 
	redirect back
end

get '/logout' do
	session[:user] = nil
	redirect to('/')
end

post '/new_user' do
	if params[:login].empty? or params[:name].empty? or params[:password].empty?
		session[:error] = "Empty=)"
		redirect to('/sign_up')
	end	
	
	user = User.first(:login => params[:login])

	if user == nil
		user = User.create(
			:name => params[:name],
			:login => params[:login],
			:password => params[:password]
		)
		user.save	
		redirect to('/')
	else
		session[:error] = "Incorect !!!"
		redirect to('/sing_up')
	end
end

#---------------- TODO ----------------
#Створити коректний календар, додати можливість динамічно 
#завантажуват місяці, переглядати події, пошук подій, сортування
#подій...

get '/calendar' do
	@calendar = 1...31 
	erb :calendar
end	

get '/all_user' do
	@users = Users.all
	erb :all_user
end

get '/new_post' do
	login?

	erb :new_post
end

post '/save_post' do
	login?

	if params[:title].empty? or params[:text].empty?
		params[:error] = 'Empty content'
		redirect to('/new_post')
	end

	post = Post.create(:title => params[:title], 
					   :text => params[:text], 
					   :user_id => session[:user].id)
	post.save
	redirect to('/')
end	

get '/post/:id' do
	@post = Post.first(:id => params[:id])
	if @post == nil
		session[:error] = "Empty post"
		redirect back
	end
	@comments = Comment.all(:post_id => params[:id])
	erb :post
end

post '/new_comment' do
	login?("post/#{ params[:post_id] }")

	if params[:text].empty?
		session[:error] = 'Empty comment'
		redirect back
	end

	comment = Comment.create(:text => params[:text],
							 :post_id => params[:post_id],
							 :user_id => session[:user].id)
	comment.save

	redirect back
end

def login?(route='/')
	if session[:user] == nil
		session[:error] = 'Authenticate!'
		redirect to(route)	
	end
end