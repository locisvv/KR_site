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
  	has n, :album
  	has n, :photo
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
	property :name,  	  String
	property :created_at, Integer, :default => Time.now.to_i

	belongs_to :user
	belongs_to :album
end