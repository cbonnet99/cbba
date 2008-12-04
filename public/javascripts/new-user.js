$(document).ready(function(){
    if ($("#user_professional").is(":checked")) {
        $("#fieldset-professional-details").show();
    }
    else {
        $("#fieldset-professional-details").hide();
    };
    $("#user_professional").click(function() {
        $("#fieldset-professional-details").toggle();
    });

    $("select#user_region_id").change(function(){
        $.getJSON("/regions/"+$(this).val()+".js/districts",{
        }, function(j){
            var options = "<option value=''>- Please select -</option>";
            for (var i = 0; i < j.length; i++) {
                options += '<option value="' + j[i].optionValue + '">' + j[i].optionDisplay + '</option>';
            }
            $("select#user_district_id").html(options);
        })
    })

});
