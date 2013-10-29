post '/post/upload_photo' do

	album = Album.new(name:    params[:title],
					  subtext: params[:subtext])
	unless album.save
		flach[:error] = @@errors[:incorrect_value]
		redirect '/post/new'
	end

	photos = params[:img]

	photos.each do |photo|
		print "+++++++++" + photo.to_s
		print "=========" + album.id.to_s

		photo_item = upload_photo(photo[1], "photos")
		photo_item.update(album_id: album.id)
	end

	redirect '/'
end

get '/albums/:id' do
	@album = Album.first(:id => params[:id])
	@photos = Photo.all(:album_id => params[:id])

	erb :album
end