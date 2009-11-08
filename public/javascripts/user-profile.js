var timeout    = 500;
var closetimer = 0;

function add_content_open()
{  add_content_canceltimer();
   add_content_close();
   $("ul#new-content-menu").css('visibility', 'visible');}

function add_content_close()
{  $("ul#new-content-menu").css('visibility', 'hidden');}

function add_content_timer()
{  closetimer = window.setTimeout(add_content_close, timeout);}

function add_content_canceltimer()
{  if(closetimer)
   {  window.clearTimeout(closetimer);
      closetimer = null;}}

$(document).ready(function(){
	$('#create-new-content').bind('mouseover', add_content_open);
	$('#create-new-content').bind('mouseout',  add_content_timer);
	
    $("ul#profile-tabs li").each(
        function(intIndex){
            $(this).hover(
                function() {
                    $(this).addClass('hover-tab');
                },
                function() {
                    $(this).removeClass('hover-tab');
                }
                );
        }
        );
});