$.extend({URLEncode:function(c){var o='';var x=0;c=c.toString();var r=/(^[a-zA-Z0-9_.]*)/;
  while(x<c.length){var m=r.exec(c.substr(x));
    if(m!=null && m.length>1 && m[1]!=''){o+=m[1];x+=m[1].length;
    }else{if(c[x]==' ')o+='+';else{var d=c.charCodeAt(x);var h=d.toString(16);
    o+='%'+(h.length<2?'0':'')+h.toUpperCase();}x++;}}return o;},
URLDecode:function(s){var o=s;var binVal,t;var r=/(%[^%]{2})/;
  while((m=r.exec(o))!=null && m.length>1 && m[1]!=''){b=parseInt(m[1].substr(1),16);
  t=String.fromCharCode(b);o=o.replace(m[1],t);}return o;}
});

$(document).ready(function(){
    $('#pics-resident-experts').cycle({fx: 'fade', pause: '1', prev: '#prev-expert', next: '#next-expert'});
    $('#ad-banners').cycle({fx: 'fade', pause: '1'});
    $("#what").autocomplete(sbg).setOptions({matchContains: true});
    $("#where").autocomplete(lts).setOptions({matchContains: true});
	$("input#what").focus();

    $("form#bam-search-form").submit(function() {
        var action = "/search";
        if ($("input#what").val() != "") {
            action = action + "/what/" + $.URLEncode($("input#what").val());
        }
        if ($("input#where").val() != "") {
            action = action + "/where/" + $.URLEncode($("input#where").val());
        }
        this.action = action;
        this.submit();
    });

    $('a.bam-show-more-details').click(function() {
        $(this).hide()
        .next('div.bam-user-details').fadeIn()
		.next().next('div.bam-user-details-icons').fadeIn();
        $.get("/search/"+$(this).attr("id")+"/count_show_more_details");
        return false;
    });
});

U_Core = {};

