$("input.submit[name=process]").click(function() {
	$("input.submit[name=process]").val("Processing...");
	$("input.submit[name=process]").unbind('click');
	$(".register-actions").removeClass('register-actions-active');
});

$("#use-different-card").click(function(){
	$("#payment-different-credit-card").show();
	}
);
$("#store_card_help_link").click(function(){
	$("#store_card_help").show();
})