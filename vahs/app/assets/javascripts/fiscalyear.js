//= require jquery
//= require jquery-ui

$(document).ready(function()
{
	function enableDateEntry()
	{
		$('.fy-date-entry').datepicker({
			changeDay: true,
			changeMonth: true,
			changeYear: true,
			showButtonPanel: true,
			dateFormat: 'yy-mm-dd',
			onClose: function(dateText, inst) {
				$(this).datepicker('setDate', new Date(inst.selectedYear, inst.selectedMonth, inst.selectedDay)); 
			}
		});
	}

	function addFiscalYear()
	{
		var fy_list = document.getElementById('fiscal-years-list');
		var rand_id = 1000 + Math.floor(Math.random() * 100);

		fy_list.innerHTML += '<div class="fiscal-year-entry">\n';
		fy_list.innerHTML += '  <input type="text" name="fy_begin[]" id="" value="" alt="Begin Date" class="fy-date-entry">\n';
		fy_list.innerHTML += '  <input type="text" name="fy_end[]" id="" value="" alt="End Date" class="fy-date-entry">\n';
		fy_list.innerHTML += '  <input type="checkbox" name="fy[]" id="" value="' + rand_id + '" alt="Remove Fiscal Year range" class="fy-date-remove-checkbox">\n';
		fy_list.innerHTML += '</div>\n';

		enableDateEntry();
	}

	
	enableDateEntry();
	$('#btnAddFY').on('click', addFiscalYear);
});
