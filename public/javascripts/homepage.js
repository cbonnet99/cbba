$(document).ready(function(){
    $(".homepage-small-user").mouseover(function(){
        $(this).css({backgroundColor: '#666', 'border': '1px solid black', cursor: 'pointer'});
    });
    $(".homepage-small-user").mouseout(function(){
        $(this).css({backgroundColor: '#b3c4d4', 'border': '0', cursor: 'default'});
    });
});