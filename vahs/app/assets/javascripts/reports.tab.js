$('select').select2({
	placeholder: "All",
	allowClear: true
});

function wf_update_timeout() {
  var s = $('#wfr-timer').text();
  s = parseInt(s) + 1;

  $('#wfr-timer').text(s);

  if($('#wfr-generating').is(':visible')) {
    setTimeout(wf_update_timeout, 1000);
  }
}

$('#hr-reports-snapshot').submit(function() {
  var btn = $(document.activeElement);

  if(!btn.is('[name=cancel]')) {
    $('#wfr-filters').hide();
    $('#wfr-timer').text('0');
    $('#wfr-generating').show();

    setTimeout(wf_update_timeout, 1000);
  }
});
