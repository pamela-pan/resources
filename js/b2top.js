//back to top
$(document).ready(function(){
	$(window).scroll(function(){
		if ($(this).scrollTop() > 80) {
			$('.back-2-top').fadeIn();
		} else {
			$('.back-2-top').fadeOut();
		}
	});
	
	$('.back-2-top').click(function(){
		$('html, body').animate({scrollTop : 0},500);
		return false;
	});
});

//scroll to the element
$(document).ready(function(){
	$('a[href^="#"]').on('click', function(event) {
    	var target = $(this.getAttribute('href'));
    	if( target.length ) {
      		event.preventDefault();
       	$('html, body').animate({
        	    scrollTop: $(target).offset().top - $('.menu').height()
        	}, 600, function(){
        		window.location.target = target;
        	});
   		}
	});
});


