get '/' do
  @post = Post.first(:order => [:created_at.desc])
  @photo = Photo.get(@post.header_photo) 
	@posts = Post.all(:order => [:created_at.desc], :limit => 4)
  @events = Event.all(:order => [:created_at.desc], :limit => 4)
  
  erb :home, :layout => false
end

get '/picasa' do
	client = Picasa::Client.new(user_id: "kajdanov@gmail.com", :password => "kajdanov??")
	

	albums = client.album.list.entries
	album = albums.find { |album| album.title == "KRT" }

  	photos = client.album.show(album.id).entries
  	photos.each do |photo| 

  		p photo.content.src
  		photo.media.thumbnails.each do |thumb|
  			p thumb.url
  			p thumb.width
  			p thumb.height
  		end	
  	end	

  	erb :calendar
end