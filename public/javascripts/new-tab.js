$(document).ready(function(){
	$("select#tab_title").change( function() {
		var defaultContentText = "<h3>About __SUBCAT_NAME__</h3> <p>Give a summary here of your service&nbsp;(Just delete this text and the heading to remove it from your profile)</p> <h3>Key benefits</h3> <div> <ul> <li>List a benefit here (or delete this text)</li> <li>List a benefit here (or delete this text)</li> <li>List a benefit here (or delete this text)</li> </ul> </div> <h3>My Training</h3> <div> <ul> <li>List your training here (or delete this text)</li> <li>List your training here&nbsp;(or delete this text)</li> <li>List your training here&nbsp;(or delete this text)</li> </ul> </div> <h3>What you can expect...</h3> <p>Write about what people can expect from you and your service... (Just delete this text and the heading to remove it from your profile)</p> <h3>About __USER_NAME__</h3> <p>Tell people something about yourself and how you connect with the service... (Just delete this text and the heading to remove it from your profile)</p>"
		var userName = $("ul#navMembers li:first").html().split(' ')[0];
		var subcatName = $(this).val();
		var transformedContentText = defaultContentText.replace(/__SUBCAT_NAME__/, subcatName).replace(/__USER_NAME__/, userName);
		$("textarea#tab_content").val(transformedContentText);
		$("textarea#tab_content").show();
		$("input[name='create']").show();
		$("label[for='tab_content']").show();
	});
});