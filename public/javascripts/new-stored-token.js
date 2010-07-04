$("input.submit[value=Save]").click(function() {
	$("input.submit[value=Save]").val("Processing...");
	$("input.submit[value=Save]").unbind('click');
	$(".register-actions").removeClass('register-actions-active');
})