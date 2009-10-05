$(document).ready(function(){
    $("select#user_main_role").change(function(){
		console.log(this.value);
		if (this.value == 'Free listing') {
			$("#dates-resident-expert").hide();
			$("#dates-full-member").hide();
			$("#subcategory-resident-expert").hide();
		}
		if (this.value == 'Full member') {
			$("#dates-resident-expert").hide();
			$("#dates-full-member").show();
			$("#subcategory-resident-expert").hide();
		}
		if (this.value == 'Resident expert') {
			$("#dates-resident-expert").show();
			$("#dates-full-member").hide();
			$("#subcategory-resident-expert").show();
		}
    })

});
