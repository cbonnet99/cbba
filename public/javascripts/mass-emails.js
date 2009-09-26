var changeNewsletter = function(){
	console.log("value: "+$("select#mass_email_email_type option:selected").text());
	if ($("select#mass_email_email_type option:selected").text() == 'Public newsletter' || $("select#mass_email_email_type option:selected").text() == 'Business newsletter') {
		$("#newsletters_list").css("display", "block");
		console.log("select#mass_email_newsletter: "+$("select#mass_email_newsletter_id option:selected"));
		console.log("select#mass_email_newsletter value: "+$("select#mass_email_newsletter_id option:selected").text());
		$("#mass_email_subject").val($("select#mass_email_newsletter_id option:selected").text());
		$("#mass_email_body_wrapper").css("display", "none")
	}
	else {
		$("#newsletters_list").css("display", "none");			
		$("#mass_email_subject").val("");
		$("#mass_email_body_wrapper").css("display", "block")
	};
	
};

$(document).ready(function(){
	changeNewsletter();
    $("select#mass_email_email_type").change(changeNewsletter);
	$("select#mass_email_newsletter_id").change(function(){
		$("#mass_email_subject").val($("select#mass_email_newsletter_id option:selected").text());
	});
});
