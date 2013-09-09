get '/' do
	@posts = Post.all
  	erb :home
end