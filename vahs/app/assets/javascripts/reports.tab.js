$('select').select2({
	placeholder: "All",
	allowClear: true
});

$('[data-collapse-parent]').click(function() {
  var parent_id = $(this).attr('data-collapse-parent');
  var children = $('[data-collapse-child="' + parent_id + '"]');

  $(this).find('.ui-icon').toggleClass("ui-icon-triangle-1-e ui-icon-triangle-1-s");

  children.each(function(i, obj) {
    var cparent_id = $(this).attr('data-collapse-parent');
    var grandchildren = $('[data-collapse-child="' + cparent_id + '"]');

    $(this).toggleClass('hidden');

    if(!$(this).is(':visible')) {
      $(this).find('.ui-icon').
        removeClass("ui-icon-triangle-1-e ui-icon-triangle-1-s").
        addClass("ui-icon-triangle-1-e");

      grandchildren.each(function() {
        $(this).find('.ui-icon').
          removeClass("ui-icon-triangle-1-e ui-icon-triangle-1-s").
          addClass("ui-icon-triangle-1-e");
        $(this).addClass("hidden");
      });
    }
  });
});
