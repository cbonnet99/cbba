$(document).ready(function(){
    var change_districts = function(j){
           var options = "<option value=''>- Please select -</option>";
           for (var i = 0; i < j.length; i++) {
               options += '<option value="' + j[i].id + '">' + j[i].name + '</option>';
           }
           $("select#user_district_id").html(options);
           $("#user_districts_comment").hide();
           $("#user_district_id").show();
       };
    
    var change_regions = function(j){
              var options = "<option value=''>- Please select -</option>";
              for (var i = 0; i < j.length; i++) {
                  options += '<option value="' + j[i].id + '">' + j[i].name + '</option>';
              }
              $("select#user_region_id").html(options);
              $("#user_district_id").hide();
              $("#user_districts_comment").show();
    };
    
    $("#user_country_id").change(function() {
       $.getJSON("/countries/regions/"+$(this).val()+".json",{
       }, change_regions);
    });
    
    $("#user_region_id").change(function() {
       $.getJSON("/regions/districts/"+$(this).val()+".json",{
       }, change_districts);
    });
    
    var country_id = $("#user_country_id").val();
    
    if (country_id === null) {
        $("#user_district_id").hide();
        $("#user_districts_comment").show();
    }
    else {
        $.getJSON("/countries/regions/"+country_id+".json",{
        }, change_regions);
        
    };
    
    
});
