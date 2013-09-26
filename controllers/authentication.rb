get '/sign_in' do
	if session[:user]
		flash[:error] = @@errors[:logged_in]
		redirect '/'
	else
		erb :sign_in
	end
end	

post '/sign_in' do
	if params[:login].empty? or params[:password].empty?
		flash[:error] = @@errors[:empty_input]
		redirect back
	end

	user = User.first(:login => params[:login], :password => params[:password])
	
	if user
		session[:user] = user
		redirect '/'
	else
		flash[:error] = @@errors[:login]
		redirect '/sign_in'
	end 
end

get '/sign_up' do
	if session[:user]
		flash[:error] = @@errors[:logged_in]
		redirect '/'
	else
		erb :sign_up
	end
end

post '/sign_up' do
	if session[:user]
		flash[:error] = @@errors[:registered]
		redirect back
	end

	user = User.create(params[:user])

	if user.valid?
		user.save
		redirect '/'
	else
		flash[:error] = user.errors.collect do |k,v|
        	"#{k} #{v}"
      	end.join(' ')

		redirect '/sign_up'
	end
end

get '/logout' do
	session[:user] = nil
	redirect '/'
end