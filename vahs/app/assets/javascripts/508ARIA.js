
$( document ).ready(function() {
	/* 508 Append ARIA tags using the 'alt' attribute */

	$.each($('a'), function(k,obj){
		var alt = $(obj).attr('alt');
		$(obj).attr('title',alt).attr('aria-label',alt).attr('aria-describedby',alt).attr('aria-labelledby',alt);
	});

	$.each($('select'), function(k,obj){
		var alt = $(obj).attr('alt');
		$(obj).attr('title',alt).attr('aria-label',alt).attr('aria-describedby',alt).attr('aria-labelledby',alt);
	});

	$.each($('label'), function(k,obj){
		var alt = $(obj).attr('alt');
		$(obj).attr('title',alt).attr('aria-label',alt).attr('aria-describedby',alt).attr('aria-labelledby',alt);
	});

	$.each($('input'), function(k,obj){
		var alt = $(obj).attr('alt');
		$(obj).attr('title',alt).attr('aria-label',alt).attr('aria-describedby',alt).attr('aria-labelledby',alt);
	});

	$.each($('button'), function(k,obj){
		var alt = $(obj).attr('alt');
		$(obj).attr('title',alt).attr('aria-label',alt).attr('aria-describedby',alt).attr('aria-labelledby',alt);
	});

	$.each($('img'), function(k,obj){
		var alt = $(obj).attr('alt');
		$(obj).attr('title',alt).attr('aria-label',alt).attr('aria-describedby',alt).attr('aria-labelledby',alt);
	});
});