$(document).ready(function(){
    $('#pics-resident-experts').cycle({fx: 'fade', pause: '1', prev: '#prev-expert', next: '#next-expert'});
    $("#fuzzy_what").autocomplete(subcategories).setOptions({matchContains: true});
    $("#fuzzy_where").autocomplete(locations).setOptions({matchContains: true});
});

U_Core = {};


U_Core.F_SelectCounter = function(id) {
        //save the selection to the server
        $.get("/search/"+id+"/select_counter");

        //unselect all categories
        $("ul.left-items li").each(
            function(intIndex){
                $(this).removeClass("selected");
            }
        );
            
        //select new current item
        $(this).addClass("selected");        
};

U_Core.F_SelectCategory = function(id, category_name) {
        //save the selection to the server
        $.get("/search/"+id+"/select_category");

        //unselect all categories
        $("ul.left-items li").each(
            function(intIndex){
                $(this).removeClass("selected");
            }
        );

        //select new current category
        $(this).addClass("selected");

        //Change the value of the search hidden field
//        $("#search_category_id").get(0).value = ""+id;

        //change the drop-down for subcategories
//        $.getJSON("/categories/"+id+".js/subcategories",{
//        }, function(j){
//            var options = "<option value=''>All "+category_name+"</option>";
//            for (var i = 0; i < j.length; i++) {
//                options += '<option value="' + j[i].optionValue + '">' + j[i].optionDisplay + '</option>';
//            }
//            $("select#what").html(options);
//        });
}
