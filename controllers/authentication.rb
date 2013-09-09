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

		redirect to('/')
	end
end

get '/logout' do
	session[:user] = nil
	redirect to('/')
end