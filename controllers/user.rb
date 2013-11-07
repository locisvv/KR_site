# encoding: utf-8
get '/my_page' do
	login?
	erb :my_page
end

post '/save_user_photo' do 
	file = params[:img][:tempfile]

	user = User.get(session[:user].id)

	if user and file
		user.photo_name = user.id.to_s + ".jpg"
		upload_photo(file, user.photo_name)
		
		user.save
	end

	redirect back
end