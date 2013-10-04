class User
  include DataMapper::Resource

	property :id,        Serial
	property :name, String, :length => (3..40), :messages => {:length => @@errors[:length]}

	property :email,     String, :length => (5..40), :unique => true, :format => :email_address,
			 :messages => {
		      	:is_unique => @@errors[:unique_email],
		      	:format    => @@errors[:incorrect_email]
			 }
	property :login,     String, :length => (3..40), :unique => true,
			 :messages => {
			 	:length => @@errors[:length],
			 	:is_unique => @@errors[:unique_login]
			 }

	property :password,  String, :length => (6..40), :messages => {:length => @@errors[:length_password]}
	property :photo_name, 	String

  	has n, :posts
  	has n, :comment
end

class Post
	include DataMapper::Resource

	property :id,    	    Serial
	property :title, 	String, :length => (3..40), :messages => {:length => @@errors[:length]}
	property :header_photo, Integer
	property :title_photo,  Integer
	property :subtext,	    Text, :length => (3..100), :messages => {:length => @@errors[:length]}	
	property :text,  	    Text
	property :created_at,   Integer, :default => Time.now.to_i

	belongs_to :user
	has n, :comment
end
class Event
	include DataMapper::Resource

	property :id,    	Serial
	property :title, 	String, :length => (3..40), :messages => {:length => @@errors[:length]}
	property :subtext,	Text, :length => (3..100), :messages => {:length => @@errors[:length]}

	property :created_at,   Integer, :default => Time.now.to_i
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
	property :small,  	  Text
	property :medium,  	  Text
	property :large,  	  Text
	property :origin,  	  Text
	property :created_at, Integer, :default => Time.now.to_i

	property :album_id,   Integer, index: true
	# property :post_id,    Integer, index: true
end