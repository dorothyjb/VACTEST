//= require jquery.table2excel

$( document ).ready(function() {
	var d = null;
	
	$('#docdate').datepicker({
        changeMonth: true,
        changeYear: true,
        showButtonPanel: true,
        dateFormat: 'yy-mm',
        onClose: function(dateText, inst) { 
            $(this).datepicker('setDate', new Date(inst.selectedYear, inst.selectedMonth, 1));
        }
    });

	if($('#docdate').val().length == 0){
		d = new Date(2013, 1, 1);
		$('#docdate').val("2013-02");
		$('#docdate').datepicker("option","defaultDate",d);
		$('#docdate').datepicker("setDate",d);
	}else{
		var parts = $('#docdate').val().split("-");
		d = new Date(parts[0],(parts[1]-1), 1);
		$('#docdate').val(parts[0]+"-"+parts[1]);
		$('#docdate').datepicker("option","defaultDate",d);
		$('#docdate').datepicker("setDate",d);
	}

});
