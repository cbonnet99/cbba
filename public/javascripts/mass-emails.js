$(document).ready(function(){
	console.log("Ready");
    $("select#mass_email_email_type").change(function(){
		console.log("select: "+this.value);
		if (this.value == 'Newsletter') {
			$("#newsletters_list").css("display", "block");
			console.log("select#mass_email_newsletter: "+$("select#mass_email_newsletter option:selected"));
			console.log("select#mass_email_newsletter.value: "+$("select#mass_email_newsletter option:selected").text());
			$("#mass_email_subject").val($("select#mass_email_newsletter option:selected").text());
		}
		else {
			$("#newsletters_list").css("display", "none");			
			$("#mass_email_subject").val("");
		};
		
    });
});
