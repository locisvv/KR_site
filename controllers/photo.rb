# encoding: utf-8
post '/post/upload_photo' do

	album = Album.new(name:    params[:title], subtext: "")
	
	unless album.save
		flach[:error] = @@errors[:incorrect_value]
		redirect '/post/new'
	end

	photos = params[:img]

	photos.each do |photo|
		photo_item = upload_photo(photo[1], "photos")
		photo_item.update(album_id: album.id)
	end

	redirect '/'
end

get '/album/:id' do
	@album = Album.first(:id => params[:id])
	@photos = Photo.all(:album_id => params[:id])

	erb :album
end

get '/all_albums' do
	@albums = Album.all

	erb :all_albums
end