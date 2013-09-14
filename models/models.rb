class User
  include DataMapper::Resource

	property :id,         	Serial
	property :name,       	String
	property :email,	  	String	
	property :login,      	String
	property :password,   	String
	property :photo_name, 	String

  	has n, :posts
  	has n, :comment
end

class Post
	include DataMapper::Resource

	property :id,    	    Serial
	property :title,        String
	property :header_photo, Integer
	property :subtext,	    Text	
	property :text,  	    Text
	property :created_at,   Integer, :default => Time.now.to_i

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

class Album 
	include DataMapper::Resource

	property :id,    	  Serial
	property :name,  	  String
	property :created_at, Integer, :default => Time.now.to_i

	belongs_to :user
	has n, :photo	
end

class Photo
	include DataMapper::Resource

	property :id,    	  Serial
	property :title,  	  String
	property :album_id,   Integer
	property :small,  	  Text
	property :medium,  	  Text
	property :large,  	  Text
	property :origin,  	  Text
	property :created_at, Integer, :default => Time.now.to_i

	property :album_id, Integer, index: true
	property :post_id,   Integer, index: true
end