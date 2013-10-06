get '/event/:id' do
	@event = Event.get(params[:id])

	erb :event
end

post '/event/new' do
	date = Time.new(params[:year].to_i, 
				params[:month].to_i,
				params[:day].to_i)

	event = Event.create(params[:event])
	event.date = date.to_i

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