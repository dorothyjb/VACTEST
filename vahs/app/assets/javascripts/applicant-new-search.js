function applicant_search(obj, path, focus)
{
  obj.autocomplete({
    minLength: 0,
    autoFocus: focus,

    source: function(req, resp) {
      $.ajax({
        url: path,
        dataType: 'json',  
        data: {
          applicant: {
            lname: $('#applicant_lname').val(),
            fname: $('#applicant_fname').val(),
          },
        },

        success: function(data) {
          resp(data)
          $.get($('#new_applicant').attr('action'), $('#new_applicant').serialize(), null, 'script');
        },

        error: function(xhdr, text, thrown) {
          console.log("There was an error receiving a names list.")
          console.log(thrown);
        },
      });
    },
  });
}

function params_of_href(href)
{
  var _href = href.split('?')[1];
  var _params = _href.split('&');
  var i, params = Array();

  for(i = 0; i < _params.length; i++) {
    var temp = _params[i].split('=');
    params[temp[0]] = temp[1];
  }

  return params;
}


$(function() {
  applicant_search($('#applicant_fname'), '/rms/applicant/new_search/first', true);
  applicant_search($('#applicant_lname'), '/rms/applicant/new_search/last', false);

  $(document).on('click', '#view_applicants .pagination a', function() {
    var _page = params_of_href(this.href)['page'];

    $.ajax({
      url: this.href,
      dataType: 'script',
      data: {
        applicant: {
          lname: $('#applicant_lname').val(),
          fname: $('#applicant_fname').val(),
        },
        page: _page,
      },
    });
    return false;
  });
});
