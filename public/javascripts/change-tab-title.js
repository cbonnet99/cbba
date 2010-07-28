$(document).ready(function(){
	$("select#tab_title").change( function() {
		var userName = $("ul#navMembers li:first").html().split(' [')[0];
		var subcatName = $(this).val();
		$("li.selected-tab").text(subcatName);
		$("input[name='create']").show();
		$("label[for='tab_content1_with']").text(subcatName+" with "+userName);
		$("label[for='tab_content1_with']").show();
		$("label[for='tab_content2_benefits']").text("Benefits of "+subcatName);
		$("label[for='tab_content2_benefits']").show();
		$("label[for='tab_content3_training']").text(userName+"'s Training");
		$("label[for='tab_content3_training']").show();
		$("label[for='tab_content4_about']").text("About "+userName);
		$("label[for='tab_content4_about']").show();
	});
});