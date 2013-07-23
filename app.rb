# encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'data_mapper' 
require 'mini_magick'
require 'dropbox_sdk'
#--------------TODO--------------
#1.  Відправки email при реєестрації
#2. -Зменшення фотографій
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
#13. Зaвантаження файлів через Amazon S3
#14. AJAX запроси
#--------------------------------

# https://devcenter.heroku.com/articles/heroku-postgresql#connecting-in-ruby 
# - використовувати для налаштування бази даних і не забути DataMapper.auto_migrate!
DataMapper.setup(:default, ENV['DATABASE_URL'] || 'postgres://postgres:80502457135@localhost/db')
# DataMapper.setup(:default, ENV['DATABASE_URL'] || 'sqlite://database.db')

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
# DataMapper.auto_migrate!
DataMapper.auto_upgrade!

enable :sessions

@@dropboxClient

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

		# if params[:img].empty?
		# 	file = params[:img][:tempfile]
		# 	File.open("./public/photo/{user.id}", 'wb') do |f|
		# 		f.write(file.read)
		# 	end
		# 	user.photo_name = user.id
		# 	user.save
		# end

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

		image.resize "200x200"
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

	@comment = Comment.create(:text => params[:text],
							 :post_id => params[:post_id],
							 :user_id => session[:user].id)
	
	print @comment.save
	
	erb :comment, :layout => false
end

get '/photos' do
	erb :photos
end	

get '/upload_photo' do
	# Get your app key and secret from the Dropbox developer website
	

	@@dropboxClient.media('/1.jpg')

	# file = open('./public/photo/small/1.jpg')
	# response = client.put_file('/1.jpg', file)
	# puts "uploaded:", response.inspect

	# root_metadata = client.metadata('/')
	# puts "metadata:", root_metadata.inspect

	# contents, metadata = client.get_file_and_metadata('/1.jpg')
	# open('1.jpg', 'w') {|f| f.puts contents }

	# erb :upload_photo
end

def login?(route = '/')
	unless session[:user]
		session[:error] = 'Authenticate!'
		redirect to(route)	
	end
end

get '/dropbox_sign_in' do 
	APP_KEY = 'kbxu559ez4kx551'
	APP_SECRET = 'jua7m4tqj943lpz'
	
	flow = DropboxOAuth2FlowNoRedirect.new(APP_KEY, APP_SECRET)
	
	unless params[:access_token]
		@url = flow.start()
		erb :dropbox_sign_in
	else
		access_token, user_id = flow.finish(params[:access_token])

		@@dropboxClient = DropboxClient.new(access_token)
		@@dropboxClient.account_info().inspect
	end	
end