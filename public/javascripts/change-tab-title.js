$(document).ready(function(){
	$("select#tab_subcategory_id").change( function() {

        var userName = $("ul#navMembers li:first").html().split(' [')[0];
        var subcatName = $("select#tab_subcategory_id option:selected").text();
        $("li.selected-tab").text(subcatName);
        $("input[name='create']").show();
        $("label[for='tab_content1_with']").text(subcatName+" with "+userName);
        $("label[for='tab_content1_with']").show();
        $("label[for='tab_content2_benefits']").text("Benefits of "+subcatName);
        $("label[for='tab_content2_benefits']").show();
        $("label[for='tab_content3_training']").text("Training");
        $("label[for='tab_content3_training']").show();
        $("label[for='tab_content4_about']").text("About "+userName);
        $("label[for='tab_content4_about']").show();

        tinyMCE.init({
        mode : "textareas",
        theme : "advanced",
        plugins : "safari,pagebreak,style,layer,table,save,advhr,advimage,advlink,iespell,print,contextmenu,paste,fullscreen,noneditable,visualchars,nonbreaking,xhtmlxtras,template",
        theme_advanced_buttons1 : ",bold,italic,underline,strikethrough,|,justifyleft,justifycenter,justifyright,justifyfull,|,formatselect",
        theme_advanced_buttons2 : "cut,copy,pastetext,pasteword,code,|,search,replace,|,bullist,numlist,|,undo,redo",
        theme_advanced_buttons3 : "",
        theme_advanced_toolbar_location : "top",
        theme_advanced_toolbar_align : "left",
        theme_advanced_statusbar_location : "bottom",
        theme_advanced_resizing : true,
        editor_deselector : "noHTMLEditor",
        extended_valid_elements : "a[name|href|target|title|onclick],img[class|src|border=0|alt|title|hspace|vspace|width|height|align|onmouseover|onmouseout|name],hr[class|width|size|noshade],font[face|size|color|style],span[class|align|style]",
        template_external_list_url : "example_template_list.js",
        use_native_selects : true,
        theme_advanced_blockformats : "p,h2,h3,h4",
        paste_auto_cleanup_on_paste : true,
        paste_remove_spans : true,
        paste_remove_styles : true,
        paste_text_use_dialog: true
        });        
	});
});