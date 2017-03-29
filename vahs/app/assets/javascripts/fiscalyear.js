//= require jquery
//= require jquery-ui

function selectDate(input)
{
	$('.fy-date-entry').datepicker({
		changeDay: true,
		changeMonth: true,
		changeYear: true,
		showButtonPanel: true,
		dateFormat: 'yy-mm-dd',
	});
}

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
		var len_id = $('.fiscal-year-entry').length + 1;

		$('#fiscal-years-list').append(
			'<tr id="fiscal-year-entry_' + len_id + '" class="fiscal-year-entry">\n' +
			'  <td><input type="checkbox" name="fy[]" id="" value="' + len_id + '" alt="Remove Fiscal Year range" class="fy-date-remove-checkbox"></td>\n' +
			'  <td><input type="text" name="fy_begin[]" id="" value="" alt="Begin Date" class="fy-date-entry"></td>\n' +
			'  <td><input type="text" name="fy_end[]" id="" value="" alt="End Date" class="fy-date-entry"></td>\n' +
			'</tr>\n');

		enableDateEntry();
	}

	function removeFiscalYear()
	{
		$('input[type=checkbox]').each(function() {
			if(this.checked) {
				$('#fiscal-year-entry_' + this.value).remove();
			}
		});
	}

	enableDateEntry();
	$('#btnAddFY').on('click', addFiscalYear);
	$('#btnRemoveFY').on('click', removeFiscalYear);
});
