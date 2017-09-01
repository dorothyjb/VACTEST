$(document).ready(function() {
	$('#tab-nav').tabs({
    activate: function(event, ui) {
      $('input[name=current_tab]').val(ui.newPanel.attr('id'));
    },
  }).addClass("ui-tabs-vertical ui-helper-clearfix");
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

  $(document).on ('change', '#status_separation_reason', function(){
    var str = $(this).val();

    if(str == "Termination" || str == "Transfer" || str == "Other") {
      $('#term_notes').removeClass('hide-element');
    } else {
      $('#term_notes').addClass('hide-element');
    }
  });

  $(document).on ('change', '#telework1', function(){
    var str = $(this).val();

    if(str == "Remote") {
      $('#telework_schedule').removeClass('hide-element');
    } else {
      $('#telework_schedule').addClass('hide-element');
    }
  });

  $(document).on ('change', '#other_assignments', function(){
    var str = $(this).val();

    if(str == "Detail To") {
      $('#detail_to').removeClass('hide-element');
    } else {
      $('#detail_to').addClass('hide-element');
    }
  });

  $(document).on ('change', '#other_assignments', function(){
    var str = $(this).val();

    if(str == "Extended Leave") {
      $('#extended_leave').removeClass('hide-element');
    } else {
      $('#extended_leave').addClass('hide-element');
    }
  });

  $('#assignment_info').change(function() {
    if($(this).val())
    {
      $.ajax({
        url: "/rms/employee/schedule_select",
        data: {
          partial: $(this).val(),
          emp: $('#emp').val(),
        },
        dataType: "html",
        method: "get",

        success: function(data) {
          $('#schedule_view').html("");
          $('#schedule_view').html(data);


        },

        error: function(xhdr, text, thrown) {
          alert(thrown);
        }
      });
    } else {
      $('#schedule_view').html("");
    }
  });

  $('#status_status_type').change(function() {
    if($(this).val())
    {
      $.ajax({
        url: "/rms/employee/status_select",
        data: {
          partial: $(this).val(),
          emp: $('#emp').val(),
        },
        dataType: "html",
        method: "get",

        success: function(data) {
          $('#status_view').html("");
          $('#status_view').html(data);


        },

        error: function(xhdr, text, thrown) {
          alert(thrown);
        }
      });
    } else {
      $('#status_view').html("");
    }
  });
  
  $('.appstat').on('change', function (e) {
    var target = $("#hold-partial-" + e.currentTarget.dataset.applicationId);
    if($(this).val())
    {

      $.ajax({
        url: "/rms/applicant/status_select",
        data: {
          partial: $(this).val(),
          app: e.currentTarget.dataset.applicationId,
        },
        dataType: "html",
        method: "get",

        success: function(data) {
          target.html("");
          target.html(data);


        },

        error: function(xhdr, text, thrown) {
          alert(thrown);
        }
      });
    } else {
      target.html("");
    }
  });

  $('#employee_on_union').on('change', function() {
    $('#on_union_view').toggle();
  });

  function blank_text(text) {
    if(text == null || text.length == 0) {
      return "(Blank)";
    }
    return text;
  }

  function org_pos_dropdown(data) {
    $('#gp_field_office').val(data.selected_office);

    $('#gp_field_division').empty();
    $('#gp_field_division').append($("<option></option>").attr("value", null).text(""));

    $.each(data.division, function(i, v) {
      $('#gp_field_division').append($("<option></option>").attr("value", v.id).text(blank_text(v.name)));
    });
    $('#gp_field_division').val(data.selected_division);

    $('#gp_field_branch').empty();
    $('#gp_field_branch').append($("<option></option>").attr("value", null).text(""));

    $.each(data.branch, function(i, v) {
      $('#gp_field_branch').append($("<option></option>").attr("value", v.id).text(blank_text(v.name)));
    });
    $('#gp_field_branch').val(data.selected_branch);

    $('#gp_field_unit').empty();
    $('#gp_field_unit').append($("<option></option>").attr("value", null).text(""));

    $.each(data.unit, function(i, v) {
      $('#gp_field_unit').append($("<option></option>").attr("value", v.id).text(blank_text(v.name)));
    });
    $('#gp_field_unit').val(data.selected_unit);

    $('#gp_field_org_code').empty();
    $('#gp_field_org_code').append($("<option></option>").attr("value", null).text(""));

    $.each(data.org_code, function(i, v) {
      $('#gp_field_org_code').append($("<option></option>").attr("value", v.id).text(v.code));
    });
    $('#gp_field_org_code').val(data.selected_org_code);
  }

  function org_pos_fetch() {
    $.ajax({
      url: "/rms/organization/dropdown",
      data: {
        office: $('#gp_field_office').val(),
        division: $('#gp_field_division').val(),
        branch: $('#gp_field_branch').val(),
        unit: $('#gp_field_unit').val(),
        org_code: $('#gp_field_org_code').val(),
        selected: $(this).attr("name"),
      },
      dataType: "json",
      method: "get",
      success: org_pos_dropdown,
      error: function(xhdr, text, thrown) {
        alert(thrown);
      }
    });
  }

  $('#gp_field_office').change(org_pos_fetch);
  $('#gp_field_division').change(org_pos_fetch);
  $('#gp_field_branch').change(org_pos_fetch);
  $('#gp_field_unit').change(org_pos_fetch);
  $('#gp_field_org_code').change(org_pos_fetch);

  $('#series').change(function() {
    var sched = $('#pay_sched').val();
    var series = $(this).val();

    if(series == '0905') {
      $('#gp_ai_view').show();

      if(sched.match(/^(al|sl|es)/i)) {
        $('#gp_bmi_view').show();

        if(sched.match(/^al/i)) {
          $('#gp_president_admin').show();
        } else {
          $('#gp_president_admin').hide();
        }
      }
    } else {
      $('#gp_ai_view').hide();
      $('#gp_bmi_view').hide();
      $('#gp_president_admin').hide();
    }
  });

  $('#pay_sched').change(function() {
    var series = $('#series').val();
    var sched = $(this).val();

    if(series == '0905') {
      if(sched.match(/^(al|sl|es)/i)) {
        $('#gp_bmi_view').show();

        if(sched.match(/^al/i)) {
          $('#gp_president_admin').show();
        } else {
          $('#gp_president_admin').hide();
        }
      } else {
        $('#gp_bmi_view').hide();
        $('#gp_president_admin').hide();
      }
    }
  });

  $('#gp_field_rotation').click(function() {
    if(this.checked) {
      $('#gp_org_code_2').removeClass('hide-element');
    } else {
      $('#gp_org_code_2').addClass('hide-element');
    }
  });

  // detect form change logic. (kind of hackish and could be done better.)
  $('#employee-form').change(function() {
    $(this).data('changed', 'true');
  });

  $('#employee-form').submit(function() {
    var txt = $(document.activeElement).text();
    var changed = $(this).data('changed');

    if(txt.match(/^cancel/i)) {
      if(changed == "true") {
        if(confirm("You have unsaved changes.\nAre you sure you want to leave this page?")) {
          return true;
        }
        return false;
      }
    }
    return true;
  });

  // applicant page, for some reason included there.
  // should move this to a modify-applicant.js
  $('#applicant-form').change(function() {
    $(this).data('changed', 'true');
  });

  $('#applicant-form').submit(function() {
    var txt = $(document.activeElement).text();
    var changed = $(this).data('changed');

    if(txt.match(/^cancel/i)) {
      if(changed == "true") {
        if(confirm("You have unsaved changes.\nAre you sure you want to leave this page?")) {
          return true;
        }
        return false;
      }
    }
    return true;
  });
});
