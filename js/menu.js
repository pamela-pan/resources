//nav menu
////hide or show menu div
////menu sign shape transformation
$(document).ready(function(){
	$('.menu-sign').click(function(){
		$('.menu').slideToggle(350);
        $('div#two').toggleClass('change-two');
        $('div#one').toggleClass('change-one');
        $('div#three').toggleClass('change-three');
        // $('.menu-burger').toggleClass('menu-burger-change-three');
	});
});

////click menu, go to the element, menu closed
$(document).ready(function(){
    $('.menu a').click(function(){
        $('.menu').slideUp(300);
        $('div#two').removeClass('change-two');
        $('div#one').removeClass('change-one');
        $('div#three').removeClass('change-three');
    });
});

//***************************************************
//arrrow animation on hover
$(document).ready(function(){
    $('section:nth-child(odd) .second-half .list a').hover(function(){
        $(this).children('span.arrow').css('padding-left', '25px');
    },
    function(){
        $(this).children('span.arrow').css('padding-left', '15px');
    }); 
});

$(document).ready(function(){
    $('section:nth-child(even) .second-half .list a').hover(function(){
        $(this).children('span.arrow').css('padding-right', '25px');
    },
    function(){
        $(this).children('span.arrow').css('padding-right', '15px');
    }); 
});


//***************************************************
//button
$(document).ready(function(){
    $('#all').click(function(){
        $('#intro, #cases').removeClass('button-selected');
        $('#all').addClass('button-selected');       
        $('.ticket').fadeIn('slow');
    });
});

$(document).ready(function(){
    $('#intro').click(function(){
        $('#all, #cases').removeClass('button-selected');
        $('#intro').addClass('button-selected'); 
        $('.ticket').not('.intro').fadeOut('fast');
        $('.intro').fadeIn('slow');
    });
});

$(document).ready(function(){
    $('#cases').click(function(){
        $('#all, #intro').removeClass('button-selected');
        $('#cases').addClass('button-selected'); 
        $('.ticket').not('.cases').fadeOut('fast');
        $('.cases').fadeIn('slow');
    });
});




