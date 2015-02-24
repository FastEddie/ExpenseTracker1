$(document).ready(function(){
	
	$(document).on("click","#addBtn", displayAddExpenseDlg);
	
	$(document).on("click","#saveBtn", saveExpense);
	
	$(document).on("click", "#deleteAllBtn", deleteAll);

});