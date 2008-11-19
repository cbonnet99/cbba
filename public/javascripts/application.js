U_Core = {};

U_Core.F_SelectCategory = function(id) {
        //save the selection to the server
        $.get("/search/"+id+"/change_category");

        //change the drop-down for subcategories
        $.getJSON("/categories/"+id+".js/subcategories",{
        }, function(j){
            var options = "<option value=''>All</option>";
            for (var i = 0; i < j.length; i++) {
                options += '<option value="' + j[i].optionValue + '">' + j[i].optionDisplay + '</option>';
            }
            $("select#what").html(options);
        });
}