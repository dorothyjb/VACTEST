// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// $(document).ready(function(){
// 	$("#new_date").validate({
// 		rules: {
// 			"docdate":{
// 				required: true
// 			}
// 		},
// 	});
// });

$(document).ready(function() {
	$('#tab-nav').tabs();//.addClass("ui-tabs-vertical ui-helper-clearfix");
	$('#tab-nav li');//.removeClass("ui-corner-top").addClass("ui-corner-left");

	$('select').select2({
		placeholder: "All",
		allowClear: true
	});
});
