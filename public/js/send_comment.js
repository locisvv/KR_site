function sendComment(){
	xhr = new XMLHttpRequest();
	form = document.forms.comment_form
	comment = form.text.value;
	postId = form.post_id.value;

	params = 'text=' + encodeURIComponent(comment) + 
			 '&post_id=' + encodeURIComponent(postId);
	
	xhr.open('POST', '/new_comment?' + params, true);
	
	xhr.onreadystatechange = function() {
		if (this.readyState != 4) return;

		if (this.status != 200) {
			alert("Error!" + this.status);
			return;
		}

		div = document.getElementById('comments');
		div.appendChild(createComment(this.responseText));
	}

	xhr.send(params);
}
function createComment(text){
	container = document.createElement('div');
	container.className = 'comment';
	container.innerHTML = text;
	return container;
}
