<!DOCTYPE html>
<html>
	<head>
	    <meta name="viewport" content="width=device-width, initial-scale=1.0">
	    <link href="css/bootstrap.min.css" rel="stylesheet" ></link>
		<script src="js/jquery-2.0.3.min.js" ></script>
		<script src="js/bootstrap.min.js" ></script>

		<script src="js/app.js" ></script>
	</head>
	
	<body style="margin-left:5px;margin-right:5px">
		
		<nav class="navbar navbar-default navbar-static-top" role="navigation" style="vertical-align:central">
			<h4 style="float:left">Expense Tracker</h4>
			<button type="button" class="btn btn-default navbar-btn" id="deleteAllBtn" style="float:right">Delete All</button>
			<button type="button" class="btn btn-default navbar-btn" id="addBtn" style="float:right">Add</button>
		</nav>
		
		<div id="expenseListDiv">
		</div>
		
		<div class="modal fade" id="addDlg" tabindex="-1" role="dialog" aria-hidden="true">
			<div class="modal-dialog">
		    	<div class="modal-content">
		      		<div class="modal-header">
		        		<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
		        		<h4 class="modal-title">Add Expense</h4>
		      		</div>
		      		<div class="modal-body">
		      			<table width="100%">
		      				<tr>
		      					<td>Date:</td>
		      					<td><input type="date" id="dateTxt"></td>
		      				</tr>
		      				<tr>
		      					<td>Amount:</td>
		      					<td><input type="text" id="amtTxt"></td>
		      				</tr>
		      				<tr>
		      					<td>Desc:</td>
		      					<td><input type="text" id="descTxt"></td>
		      				</tr>
		      			</table>
		      		</div>
		      		<div class="modal-footer">
		        		<button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
		        		<button type="button" class="btn btn-primary" id="saveBtn">Save</button>
		      		</div>
		   		</div>
		  	</div><!-- /.modal-dialog -->
		</div>
	</body>
</html>


<cfclient>
	
	<cftry>
		
		<cfset expMgr = new cfc.ExpenseManager()>
		<cfset expenses = expMgr.getExpenses()>
	
		<cfcatch type="any" name="e">
			<cfset alert(e.message)>
		</cfcatch>
	</cftry>
	 
	 <cf_expenseList parentDiv="expenseListDiv" expenses=#expenses# action="displayAll">
	 
	<cffunction name="displayAddExpenseDlg" >
		<cfset $("##addDlg").modal() >
	</cffunction> 
	
	<cffunction name="saveExpense" >
		
		<cfscript>
			var dateStr = trim($("##dateTxt").val());
			var amtStr = trim($("##amtTxt").val());
			
			if (dateStr == "" || amtStr == "")
			{
				alert("Date and amount are required");
				return;
			}
			
			if (!isNumeric(amtStr))
			{
				alert("Invalid amount");
				return;
			}
			
			var amt = Number(amtStr);
			var tmpDate = new Date(dateStr);
			var desc = trim($("##descTxt").val());
			
			var expVO = new cfc.ExpenseVO(tmpDate.getTime(),amt,desc);
			var expAdded = false;
			
			try
			{ 
				expMgr.addExpense(expVO);
				expAdded = true;
			} 
			catch (any e)
			{
				alert("Error : " + e.message);
				return;
			}
		</cfscript>
		
		<cfset $("##addDlg").modal("hide") >
		
		<cfif expAdded eq true>
	 		<cf_expenseList parentDiv="expenseListDiv" expenses=#expVO# action="append">
		</cfif>
		
	</cffunction>
	
	<cffunction name="deleteAll" >
		
		<cfscript>
			if (!confirm("Are you sure you want to delete all?"))
				return;
				
			try
			{
				expMgr.deleteAllExpenses();
			} 
			catch (any e)
			{
				alert("Error : " + e.message);
				return;
			}
		</cfscript>
		
 		<cf_expenseList parentDiv="expenseListDiv" action="removeAll">
 			
	</cffunction>
</cfclient>