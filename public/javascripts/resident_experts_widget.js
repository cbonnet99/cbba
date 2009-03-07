var promowidgetindex = 0;
var promowidgetdelay = 5;
var promowidgetswf = new SWFObject("/resident_experts.swf", "promowidgetswf", "160", "230", "8", "#ffffff");promowidgetswf.addParam("menu", false);
promowidgetswf.addVariable("promowidgetdata", encodeURI(JSON.stringify(promowidgetdata).replace(/&amp;|&/g,'-AMP-')));
promowidgetswf.addVariable("promowidgetindex", promowidgetindex);
promowidgetswf.addVariable("promowidgetdelay", promowidgetdelay);
if (!promowidgetswf.write("promowidget")) { var pw = new PromoWidget('promowidget',promowidgetdata,promowidgetindex,promowidgetdelay) };