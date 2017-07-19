
$( document ).ready(function() {
	/* 508 Append ARIA label tags using the 'alt' attribute */

	$.each($('a'), function(k,obj){
		var alt = $(obj).attr('alt');
		$(obj).attr('title',alt).attr('aria-label',alt);
	});

	$.each($('select'), function(k,obj){
		var alt = $(obj).attr('alt');
		$(obj).attr('title',alt).attr('aria-label',alt);
	});

	$.each($('label'), function(k,obj){
		var alt = $(obj).attr('alt');
		$(obj).attr('title',alt).attr('aria-label',alt);
	});

	$.each($('input'), function(k,obj){
		var alt = $(obj).attr('alt');
		$(obj).attr('title',alt).attr('aria-label',alt);
	});

	$.each($('button'), function(k,obj){
		var alt = $(obj).attr('alt');
		$(obj).attr('title',alt).attr('aria-label',alt);
	});

	$.each($('img'), function(k,obj){
		var alt = $(obj).attr('alt');
		$(obj).attr('title',alt).attr('aria-label',alt);
	});
});
