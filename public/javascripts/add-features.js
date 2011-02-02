$(document).ready(function(){
    
    $("#buy_now_triple_vis").click(function(event){
       $("#order_package_triple_vis").attr('checked', 'checked');
       $("form.edit_order").submit(); 
    });
    
    $("#buy_now_stand_out").click(function(event){
       $("#order_package_stand_out").attr('checked', 'checked');
       $("form.edit_order").submit(); 
    });
    
    $("#buy_now_permium").click(function(event){
       $("#order_package_premium").attr('checked', 'checked');
       $("form.edit_order").submit(); 
    });
    
    $("li").removeClass("checked");
    $("input:checked").parents("li").addClass("checked");
});
$(".edit_order li").click(function(){
    $(this).children("input").attr('checked', 'checked');
    $("li").removeClass("checked");
    $("input:checked").parents("li").addClass("checked");
});