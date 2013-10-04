post '/event/new' do
	event = Event.create(params[:event])
	if event.valid?
		event.save
		redirect '/'
	else
		flash[:error] = event.errors.collect do |k,v|
        	"#{k} #{v}"
      	end.join(' ')

		redirect '/post/new'
	end
end