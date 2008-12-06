$(document).ready(function(){

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