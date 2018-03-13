$(function() {
  $('[data-toggle=offcanvas]').on(function () {
    if ($('.sidebar-offcanvas').css('background-color') == 'rgb(255, 255, 255)') {
	    $('.list-group-item').attr('tabindex', '-1');
    } else {
	    $('.list-group-item').attr('tabindex', '');
    }
    $('.row-offcanvas').toggleClass('active');
    
  });
});


$(document).on('click', '#panel-fullscreen', function () {
    
    var $this = $(this);

    if ($this.children('i').hasClass('glyphicon-resize-full'))
    {
        $this.children('i').removeClass('glyphicon-resize-full');
        $this.children('i').addClass('glyphicon-resize-small');
    }
    else if ($this.children('i').hasClass('glyphicon-resize-small'))
    {
        $this.children('i').removeClass('glyphicon-resize-small');
        $this.children('i').addClass('glyphicon-resize-full');
    }
    $(this).closest('.panel').toggleClass('panel-fullscreen');

    if(window.screenTop == 0 ? true : false){
    	$(this).closest('.panel').css('background-color', '#333');
    }
    else{
    	$(this).closest('.panel').css('background-color', '#fff');
    }
});


$(document).on('page:change', function () {
  
  $("#panel11").css({color: 'red', fontWeight: 'bold', display: 'none'});


  $('#btn1').on('click', function(){
  	$('#panel11').fadeToggle();

  	$('#panel11 .panel-body').html('Google is search engine Google is search engine ');

  });

  $("#btn2").on('click', function(){
  	$("#panel2").fadeToggle();
  });  
  $("#btn3").on('click', function(){
  	$("#panel3").fadeToggle();
  })
  $("#btn4").on('click', function(){
  	$("#panel4").fadeToggle(500);
  });
});