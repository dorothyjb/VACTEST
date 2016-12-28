/* 
 * JavaScript: menu
 * Adds Functionality to the Bootstrap NAVBAR implementation
 * - in app/views/layouts/_menu.html.erb
 */
$( document ).ready(function() {
	/*
	 * Color toggle the menu choices to highlight which choice is currently active 
	 */
	var path = window.location.pathname.replace('/','');
	$('a[id^="nav_"]').removeClass('active');
	if(path==''){
		$('a[id="nav_home"]').addClass('active');
	}else{	
		$('a[id="nav_'+path+'"]').addClass('active');
	}
});