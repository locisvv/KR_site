helpers do
	@@picasa_client = nil

	def upload_photo(params_file, album_name)
		get_picasa

		file = params_file[:tempfile]
		title = params_file[:filename]

		if file and title
			
			albums = @@picasa_client.album.list.entries
		  	album = albums.find { |album| album.title == album_name }

		  	@@picasa_client.photo.create(album.id,
			    {
			      	:binary => file.read,
			      	:content_type => "image/jpeg",
			      	:title => title,
			      	:summary => ""
			    }
		  	)

	  	  	photos = @@picasa_client.album.show(album.id).entries
			photo = photos.find { |photo| photo.title == title }
			
			photo_item = Photo.new( title: 		photo.title,
									album_id: 	album.id,
									small:  	photo.media.thumbnails[0].url,
									medium: 	photo.media.thumbnails[1].url,
									large:  	photo.media.thumbnails[2].url,
									origin: 	photo.content.src)
			photo_item.save

			return photo_item
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
	def get_picasa
		@@picasa_client = Picasa::Client.new(user_id: "kajdanov@gmail.com", :password => "kajdanov80502457135")	
	end	
end	