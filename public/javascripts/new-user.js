$(document).ready(function(){
    var country_id = $("#user_country_id").val(); 

    $.getJSON("/countries/districts/"+country_id+".json",{
    }, function(j){
        var options = "<option value=''>- Please select -</option>";
        for (var i = 0; i < j.length; i++) {
            options += '<option value="' + j[i].id + '">' + j[i].full_name + '</option>';
        }
        $("select#user_district_id").html(options);
    });
        
    $("#user_country_id").change(function() {
       $.getJSON("/countries/districts/"+$(this).val()+".json",{
       }, function(j){
           var options = "<option value=''>- Please select -</option>";
           for (var i = 0; i < j.length; i++) {
               options += '<option value="' + j[i].id + '">' + j[i].full_name + '</option>';
           }
           $("select#user_district_id").html(options);
       });
    });
    
});
