$(document).ready(function(){
    $('#pics-resident-experts').cycle({fx: 'fade', pause: '1', prev: '#prev-expert', next: '#next-expert'});
    $('#ad-banners').cycle({fx: 'fade', pause: '1'});
    $("#what").autocomplete(sbg).setOptions({matchContains: true});
    $("#where").autocomplete(lts).setOptions({matchContains: true});

    $("form#bam-search-form").submit(function() {
        var action = "/search";
        if ($("input#what").val() != "") {
            action = action + "/what/" + $("input#what").val().replace(/ /, '-');
        }
        if ($("input#where").val() != "") {
            action = action + "/where/" + $("input#where").val().replace(/ /, '-');
        }
        this.action = action;
        this.submit();
    });

    $('a.bam-show-more-details').click(function() {
        $(this).hide()
        .next('div.bam-user-details').fadeIn();
        $.get("/search/"+$(this).attr("id")+"/count_show_more_details");
        return false;
    });
});

U_Core = {};

