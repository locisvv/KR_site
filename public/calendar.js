
$(function(){
	var $container = $('#container');
	
	$container.isotope({
		// options
		itemSelector : '.element',
		layoutMode : 'masonry'
	});

	$container.delegate( '.element', 'click', function(){
    	$(this).toggleClass('large');
    	$container.isotope('reLayout');
    });
     // toggle variable sizes of all elements
      $('#toggle-sizes').find('a').click(function(){
        $container
          .toggleClass('variable-sizes')
          .isotope('reLayout');
        return false;
      });
}); 