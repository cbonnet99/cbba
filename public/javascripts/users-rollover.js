$(document).ready(function(){
    $(".user-rollover").mouseover(function(){
        $(this).css({backgroundColor: '#666', 'border': '1px solid black', cursor: 'pointer'});
    });
    $(".user-rollover").mouseout(function(){
        $(this).css({backgroundColor: '#b3c4d4', 'border': '1px solid white', cursor: 'default'});
    });
});