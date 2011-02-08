$(document).ready(function(){
    
    var submit_order = function(){
      if ($("form.new_order")){
          $("form.new_order").submit();
      }  
      if ($("form.edit_order")){
          $("form.edit_order").submit();
      }  
    };
        
    $("#buy_now_triple_vis").click(function(event){
       $("#order_package_triple_vis").attr('checked', 'checked');
       submit_order(); 
    });
    
    $("#buy_now_stand_out").click(function(event){
       $("#order_package_stand_out").attr('checked', 'checked');
       submit_order(); 
    });
    
    $("#buy_now_premium").click(function(event){
       $("#order_package_premium").attr('checked', 'checked');
       submit_order(); 
    });
    
    $("li").removeClass("checked");
    $("input:checked").parents("li").addClass("checked");
});
$("#add-features-list li").click(function(){
    $(this).children("input").attr('checked', 'checked');
    $("li").removeClass("checked");
    $("input:checked").parents("li").addClass("checked");
});