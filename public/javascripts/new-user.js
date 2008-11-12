$(document).ready(function(){
    $("#user_free_listing").click(function() {
        $("#fieldset-professional-details").toggle();
    });

    $("#user_professional").click(function() {
        switch (this.checked) {
            case true:
                $("#link-user-professional").show();
                break;
            default:
                $("#link-user-professional").hide();
                if (($("#fieldset-professional-details").css('display')) == 'block') {
                    $("#fieldset-professional-details").hide();
                }

        }

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
