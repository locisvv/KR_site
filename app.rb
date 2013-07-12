# encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'data_mapper' 
require 'mini_magick'
#--------------TODO--------------
#1.  Відправки email при реєестрації
#2.  Зменшення фотографій
#3.  Створення альбомів
#4.  Оптимізація запитів до БД
#5.  Добавлення фотографій до постів
#6.  Добавити дані користувача
#7.  Реєестрація через інші сайти
#8.  Адаптивний дизайн
#9.  Редактор тексту
#10. Сторінка "Про нас" 
#11. Сторінка "Календар"
#12. Глова сторінка
#--------------------------------

DataMapper.setup(:default, ENV['DATABASE_URL'] || 'sqlite:db.sqlite3')

class User
  include DataMapper::Resource

	property :id,         	Serial
	property :name,       	String
	property :email,	  	String	
	property :login,      	String
	property :password,   	String
	property :photo_name, 	String

  	has n, :posts
end

class Post
	include DataMapper::Resource

	property :id,    	  Serial
	property :title,      String
	property :subtext,	  Text	
	property :text,  	  Text
	property :created_at, Integer, :default => Time.now.to_i

	belongs_to :user
	has n, :comment
end

class Comment
	include DataMapper::Resource

	property :id,    	  Serial
	property :text,  	  Text
	property :created_at, Integer, :default => Time.now.to_i

	belongs_to :user
	belongs_to :post
end

class Photo
	include DataMapper::Resource

	property :id,    	  Serial
	property :name,  	  String
	property :created_at, Integer, :default => Time.now.to_i
end	

DataMapper.finalize
DataMapper.auto_upgrade!

enable :sessions

get '/' do
	@posts = Post.all
  	erb :home
end

get '/sign_in' do
	erb :sign_in
end	
post '/sign_in' do
	if params[:login].empty? or params[:password].empty?
		session[:error] = "Empty"
		redirect back
	end

	user = User.first(:login => params[:login], :password => params[:password])
	if user
		session[:user] = user
	else
		session[:error] = "Incorect password or login"	
	end 
	redirect to('/')
end

get '/sign_up' do
	erb :sign_up
end

post '/sign_up' do

	if params[:login].empty? or params[:name].empty? or params[:password].empty?
		session[:error] = "Empty=)"
		redirect to('/sign_up')
	end	
	
	user = User.first(:login => params[:login])

	if user
		session[:error] = "Incorect !!!"
		redirect to('/sign_up')
	else
		user = User.create(
			:name => params[:name],
			:login => params[:login],
			:email => params[:email],
			:password => params[:password]
		)
		user.save

		if params[:img].empty?
			file = params[:img][:tempfile]
			File.open("./public/photo/{user.id}", 'wb') do |f|
				f.write(file.read)
			end
			user.photo_name = user.id
			user.save
		end

		redirect to('/')
	end
end

get '/logout' do
	session[:user] = nil
	redirect to('/')
end

get '/my_page' do
	login?
	erb :my_page
end

post '/save_user_photo' do 
	file = params[:img][:tempfile]

	user = User.get(session[:user].id)

	if user
		File.open("./public/photo/#{user.id}.jpg", 'wb') do |f|
			f.write(file.read)
		end

		image = MiniMagick::Image.open("./public/photo/#{user.id}.jpg")

		image.resize "100x100"
		image.write  "./public/photo/small/" + user.id.to_s + ".jpg"

		user.photo_name = user.id.to_s + ".jpg"
		user.save
	end

	redirect back
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

	if params[:title].empty? or params[:text].empty? or params[:subtext].empty?
		params[:error] = 'Empty content'
		redirect to('/new_post')
	end

	post = Post.create(:title => params[:title], 
					   :text => params[:text],
					   :subtext => params[:subtext], 
					   :user_id => session[:user].id)
	post.save
	redirect to('/')
end	

get '/post/:id' do
	@post = Post.first(:id => params[:id])

	unless @post
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

get '/upload_photo' do
	erb :upload_photo
end

post '/upload_photo' do
	@filename = params[:img][:filename]
	file = params[:img][:tempfile]

	File.open("./public/photo/#{@filename}", 'wb') do |f|
		f.write(file.read)
	end
end

def login?(route = '/')
	unless session[:user]
		session[:error] = 'Authenticate!'
		redirect to(route)	
	end
end