$(document).ready(function(){
	$("select#tab_title").change( function() {
		var defaultContentText = "<h3>About __SUBCAT_NAME__</h3> <p>Give a summary here of your service&nbsp;(Just delete this text and the heading to remove it from your profile)</p> <h3>Key benefits</h3> <div> <ul> <li>List a benefit here (or delete this text)</li> <li>List a benefit here (or delete this text)</li> <li>List a benefit here (or delete this text)</li> </ul> </div> <h3>My Training</h3> <div> <ul> <li>List your training here (or delete this text)</li> <li>List your training here&nbsp;(or delete this text)</li> <li>List your training here&nbsp;(or delete this text)</li> </ul> </div> <h3>What you can expect...</h3> <p>Write about what people can expect from you and your service... (Just delete this text and the heading to remove it from your profile)</p> <h3>About __USER_NAME__</h3> <p>Tell people something about yourself and how you connect with the service... (Just delete this text and the heading to remove it from your profile)</p>"
		var userName = $("ul#navMembers li:first").html().split(' ')[0];
		var subcatName = $(this).val();
		var transformedContentText = defaultContentText.replace(/__SUBCAT_NAME__/, subcatName).replace(/__USER_NAME__/, userName);
		$("input[name='create']").show();
		$("label[for='tab_content']").show();
		if (typeof(tinyMCE.settings) == "undefined"){
			tinyMCE.init({
			mode : "textareas",
			theme : "advanced",
			plugins : "safari,pagebreak,style,layer,table,save,advhr,advimage,advlink,iespell,print,contextmenu,paste,fullscreen,noneditable,visualchars,nonbreaking,xhtmlxtras,template",
			theme_advanced_buttons1 : ",bold,italic,underline,strikethrough,|,justifyleft,justifycenter,justifyright,justifyfull,|,formatselect",
			theme_advanced_buttons2 : "cut,copy,paste,code,|,search,replace,|,bullist,numlist,|,undo,redo",
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
			paste_auto_cleanup_on_paste : true
			});
			$("textarea#tab_content").val(transformedContentText);
		}
		else {
			tinyMCE.activeEditor.setContent(transformedContentText);
		}
	});
});