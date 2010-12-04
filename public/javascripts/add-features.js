$(document).ready(function(){
    $("li").removeClass("checked");
    $("input:checked").parents("li").addClass("checked");    
});
$(".edit_order li").click(function(){
    $(this).children("input").attr('checked', 'checked');
    $("li").removeClass("checked");
    $("input:checked").parents("li").addClass("checked");
});