helpers do
	def upload_photo(file, nameFile)
		if file and nameFile
			image = MiniMagick::Image.read(file)
			image.resize "200x200"
			
			newFile = Tempfile.new("tempimage")

	  		image.write(newFile.path)
			
			# response = @@dropboxClient.put_file('/user_photos/small/' + nameFile, newFile)
		else
			false
		end	
	end

	def login?(route = '/')
		unless session[:user]
			session[:error] = 'Authenticate!'
			redirect to(route)	
		end
	end

	def login_required
		unless session[:user]
			flash[:error] = @@errors[:login_required]
			redirect '/login'
		end	
    end

    def site_admin!
		unless session[:user] and session[:user].permission
			flash[:error] = @@errors[:sign_in_admin]
			redirect '/'
		end		
	end		
end	