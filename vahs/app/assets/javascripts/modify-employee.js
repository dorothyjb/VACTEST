$(document).ready(function() {
	$('#tab-nav').tabs().addClass("ui-tabs-vertical ui-helper-clearfix");
	$('#tab-nav li').removeClass("ui-corner-top").addClass("ui-corner-left");

  $('.datefield').datepicker({
    changeMonth: true,
    changeYear: true,
    showButtonPannel: true,
    dateFormat: 'mm/dd/yy'
  });

  $.fn.togglepanels = function(){
    return this.each(function(){
      $(this).addClass("ui-accordion ui-accordion-icons ui-widget ui-helper-reset")
        .find("h3")
        .addClass("ui-accordion-header ui-helper-reset ui-state-default ui-corner-top ui-corner-bottom")
        .hover(function() { $(this).toggleClass("ui-state-hover"); })
        .prepend('<span class="ui-icon ui-icon-triangle-1-e"></span>')
        .click(function() {
          $(this)
            .toggleClass("ui-accordion-header-active ui-state-active ui-state-default ui-corner-bottom")
            .find("> .ui-icon").toggleClass("ui-icon-triangle-1-e ui-icon-triangle-1-s").end()
            .next().slideToggle();
            return false;
        })
        .next()
          .addClass("ui-accordion-content ui-helper-reset ui-widget-content ui-corner-bottom")
          .hide();
    });
  };

  $('.accordion').togglepanels();

  $('#vet_status').change(function() {
    var str = $('#vet_status option:selected').text();
    if(str == "Veteran") {
      $('#military_svc_branch').removeClass('hide-element');
    } else {
      $('#military_svc_branch').addClass('hide-element');
    }
  });

  $('#gp_field_office').change(function() {
    $.ajax({
      url: "/rms/orginization/office",
      data: {
        office: $(this).val()
      },
      dataType: "json",
      method: "get",

      success: function(data) {
        $('#gp_field_division').empty();
        $('#gp_field_division').append($("<option></option>").attr("value", null).text(""))
        $.each(data.division, function(i, v) {
          $('#gp_field_division').append($("<option></option>").attr("value", v.id).text(v.name));
        });

        $('#gp_field_branch').empty();
        $('#gp_field_branch').append($("<option></option>").attr("value", null).text(""))
        $.each(data.branch, function(i, v) {
          $('#gp_field_branch').append($("<option></option>").attr("value", v.id).text(v.name));
        });

        $('#gp_field_unit').empty();
        $('#gp_field_unit').append($("<option></option>").attr("value", null).text(""))
        $.each(data.unit, function(i, v) {
          $('#gp_field_unit').append($("<option></option>").attr("value", v.id).text(v.name));
        });

        $('#gp_field_org_code').empty();
        $('#gp_field_org_code').append($("<option></option>").attr("value", null).text(""))
        $.each(data.org_code, function(i, v) {
          $('#gp_field_org_code').append($("<option></option>").attr("value", v.id).text(v.code));
        });
      },

      error: function(xhdr, text, thrown) {
        alert(thrown);
      }
    });
  });

  $('#gp_field_rotation').click(function() {
    if(this.checked) {
      $('#gp_org_code_2').removeClass('hide-element');
    } else {
      $('#gp_org_code_2').addClass('hide-element');
    }
  });
});
