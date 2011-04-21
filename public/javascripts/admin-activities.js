$(document).ready(function(){
    $("#filter_activity").click(function(){
       window.location.href = "/admin/user_activities?username="+$("input#username").val(); 
    });
});