function PromoWidget(pwid, pwdata, pwindex, pwdelay) {
	// check for widget
	this.promowidget = document.getElementById(pwid);
	if (this.promowidget && pwdata.length>1) {
		// settings
		this.data = pwdata;
		this.index = pwindex;
		this.delay = pwdelay*1000;
		this.timeoutid = null;
		this.paused = false;
		// display
		this.title = document.getElementById(pwid+'_title');
		this.image = document.getElementById(pwid+'_image');
        alert(this.image);
		this.link1 = document.getElementById(pwid+'_link1');
		this.description = document.getElementById(pwid+'_description');
		this.linkholder = document.getElementById(pwid+'_linkholder');
		this.linkicon = document.getElementById(pwid+'_linkicon');
		this.link2 = document.getElementById(pwid+'_link2');
		this.nav = document.getElementById(pwid+'_nav');
		this.pause = document.getElementById(pwid+'_pause');
		// image cache
		for (var p=0; p<this.data.length; p++) {
			if (this.data[p].image=='') this.data[p].image = '/images/nophoto.gif';
			this.data[p].image_ = new Image();
		}
		this.data[this.index].image_.src=this.data[this.index].image;
		// prev/next
		this.nav.style.display = 'block';
		this.setupPrevNext();
		
		// show first promo
		this.show(this.index);
	}
}

PromoWidget.prototype.setupPrevNext = function() {
	this.prev = (this.index-1>=0) ? this.index-1 : this.data.length-1;
	this.next = (this.index+1<this.data.length) ? this.index+1 : 0;
	if (this.data[this.prev].image_.src=='') this.data[this.prev].image_.src=this.data[this.prev].image;
	if (this.data[this.next].image_.src=='') this.data[this.next].image_.src=this.data[this.next].image;
}

PromoWidget.prototype.showNext = function() {
	// clear update
	window.clearTimeout(this.timeoutid);
	this.timeoutid = null;
	
	// get next promo
	this.index = (this.index+1<this.data.length) ? this.index+1 : 0;
	this.setupPrevNext();
	this.show(this.index);
}

PromoWidget.prototype.showPrev = function() {
	// clear update
	window.clearTimeout(this.timeoutid);
	this.timeoutid = null;
	
	// get prev promo
	this.index = (this.index-1>=0) ? this.index-1 : this.data.length-1;
	this.setupPrevNext();
	this.show(this.index);
}

PromoWidget.prototype.togglePause = function() {
	if (!this.paused) {
		// clear update
		window.clearTimeout(this.timeoutid);
		this.timeoutid = null;
		
		this.paused = true;
		this.pause.innerHTML = '&nbsp;play&nbsp;';
	} else {
		// update soon
		var _this = this;
		this.timeoutid = window.setTimeout(function() { _this.showNext() }, this.delay);
		
		this.paused = false;
		this.pause.innerHTML = 'pause';
	}
}

PromoWidget.prototype.show = function(p) {
	// clear update
	window.clearTimeout(this.timeoutid);
	this.timeoutid = null;
	
	// show promo
	var promo = this.data[p];
	this.title.innerHTML = promo.title;
	this.image.src = unescape(promo.image);
	this.image.alt = promo.title;
	this.link1.href = unescape(promo.link);
	this.description.innerHTML = promo.description;
	this.link2.href = unescape(promo.link);
	
	if (promo.link=='') {
		this.linkholder.style.visibility = 'hidden';
	} else {
		this.linkholder.style.visibility = 'visible';
	}
	
	// link targets for handling by link tag - buggy
	if (!promo.newwin) {
		this.link1.target = '';
		this.link2.target = '';
		this.linkicon.src = '/images/promowidget/icon_arrow.gif';
		this.link2.innerHTML = 'Find out more';
	} else {
		this.link1.target = '_blank';
		this.link2.target = '_blank';
		this.linkicon.src = '/images/promowidget/icon_arrow_angle.gif';
		this.link2.innerHTML = 'Visit Website';
	}
	
	// bind events
	var _this = this;
	var jumper = function() { return _this.jump(_this.index) };
	this.link1.onclick = jumper;
	this.link2.onclick = jumper;
	
	// update soon
	if (!this.paused) this.timeoutid = window.setTimeout(function() { _this.showNext() }, this.delay);
}

PromoWidget.prototype.jump = function(p) {
	// check if promo opens in new window
	var promo = this.data[p];
	if (promo.newwin) {
		window.open(promo.link,'_blank');
		return false;
		// return true; // for handling by link tag - buggy
	}
	
	// clear update
	window.clearTimeout(this.timeoutid);
	this.timeoutid = null;
	
	// browsers play differently with back button
	if (!this.paused) this.togglePause();
	
	// load promo link into current window
	window.location.href = promo.link;
	return false;
}