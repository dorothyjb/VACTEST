
$( document ).ready(function() {
	var path = window.location.pathname.replace('/','');
	$('a[id^="nav_"]').removeClass('active');
	if(path==''){
		$('a[id="nav_home"]').addClass('active');
	}else{	
		$('a[id="nav_'+path+'"]').addClass('active');
	}
});