//= require jquery
//= require jquery-ui

//function addFiscalYear()
//{
	/*var fy_list = document.getElementByID('fiscal-years-list');
	var rand_id = 1000 + Math.floor(Math.random() * 100);*/

//	alert(fy_list);

	/*fy_list.inner_html += '<div class="fiscal-year-entry">';
	fy_list.inner_html += '<input type="text" name="fy_begin[]" id="" value="" alt="Begin Date" class="fy-date-entry">';
	fy_list.inner_html += '<input type="text" name="fy_end[]" id="" value="" alt="End Date" class="fy-date-entry">';
	fy_list.inner_html += '<input type="checkbox" name="fy[]" id="" value="' + rand_id + '" alt="Remove Fiscal Year range" class="fy-date-remove-checkbox">';
	fy_list.inner_html += '</div>';*/
//}

function removeFiscalYear()
{
}

$(document).ready(function()
{
	function addFiscalYear()
	{
		alert('Hello!');
	}

	$('#btnAddFY').on('click', addFiscalYear);
});
