get '/new_post' do
	login?

	erb :new_post
end

post '/save_post' do
	login?

	unless params[:title] or params[:text] or params[:subtext] or params[:img]
		params[:error] = 'Empty content'
		redirect to('/new_post')
	end

	post = Post.create(:title => params[:title],
					   :text => params[:text],
					   :subtext => params[:subtext],
					   :user_id => session[:user].id)
	post.save

	photo_header = upload_photo(params[:img], "post")
	
	photo_header.post_id = post.id
	photo_header.save

	post.update(header_photo: photo_header.id)
	redirect to('/')
end	

get '/post/:id' do
	@post = Post.first(:id => params[:id])

	unless @post
		session[:error] = "Empty post"
		redirect back
	end

	@photo_url

	@comments = Comment.all(:post_id => params[:id])
	@comments.each	do |comment|
	 	user = comment.user
	end

	erb :post
end

post '/new_comment' do
	login?("post/#{ params[:post_id] }")

	if params[:text].empty?
		session[:error] = 'Empty comment'
		redirect back
	end

	@comment = Comment.create(:text => params[:text],
	:post_id => params[:post_id],
	:user_id => session[:user].id)

	print @comment.save

	erb :comment, :layout => false
end