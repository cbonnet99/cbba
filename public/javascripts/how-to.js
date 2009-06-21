var setLastTextArea = function() {
	var lastTextAreaId = 0;
    $(".step-text-area").each(function(intIndex){
		lastTextAreaId = "step-text-area"+intIndex;
		$(this).attr("id", lastTextAreaId);
    });
	tinyMCE.execCommand('mceAddControl', false, lastTextAreaId);
};

var resetStepNumbers = function() {
    $(".step-title-number").each(function(intIndex){
        $(this).html(intIndex+1);
    });
};

var setLabelToStep = function() {
        $(".step-title-label").each(function(intIndex){
            $(this).html("Step");
            });
};

var setLabelToTip = function() {
        $(".step-title-label").each(function(intIndex){
            $(this).html("Tip");
            });
};

var resetStepLabels = function() {
    if ($('#how_to_step_label_step').is(":checked")) {
        setLabelToStep();
    }
    if ($('#how_to_step_label_tip').is(":checked")) {
        setLabelToTip();
    }
};

$(document).ready(function(){
    resetStepNumbers();
    resetStepLabels();
    $("#how_to_step_label_step").click(function() {
        setLabelToStep();
    });
    $("#how_to_step_label_tip").click(function() {
        setLabelToTip();
    });
    
});