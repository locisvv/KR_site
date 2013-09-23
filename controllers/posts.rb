before '/post/*' do
  	login_required
end

get '/post/new' do
	login?

	erb :new_post
end

post '/post/save' do
	login?

	unless params[:title] or params[:text] or params[:subtext] or params[:img]
		params[:error] = 'Empty content'
		redirect to('/new_post')
	end

	header_photo = upload_photo(params[:header_img], "post")
	title_photo = upload_photo(params[:title_img], "post")
	
	post = Post.create(title: 		 params[:title],
					   text: 	 	 params[:text],
					   subtext: 	 params[:subtext],
					   user_id: 	 session[:user].id,
					   title_photo:  title_photo.id,
					   header_photo: header_photo.id)
	post.save
	
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

post '/post/new_comment' do
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