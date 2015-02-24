component client="true"   
{
	this.dsn = "expense_db";
	
	function init()
	{
		var dbCreated = localStorage.dbCreated;
		if (!isDefined("dbCreated"))
			localStorage.dbCreated = false;
			
		if (!dbCreated)
		{
			try
			{
				createTable();
				localStorage.dbCreated = true;
			} 
			catch (any e)
			{
				alert("Error : " + e.message);
			}
		}
	}
	
	function createTable()
	{
		queryExecute(
			"create table if not exists expense (id integer primary key, 
			expense_date integer, amount real, desc text)", 
			[], 
			{"datasource":this.dsn});
	}

	function addExpense (expVO)
	{
		queryExecute(
			"insert into expense (expense_date,amount,desc) values(?,?,?)",
			[expVO.expenseDate,expVO.amount,expVO.description],
			{"datasource":this.dsn}
		);
		
		//get auto generated id
		queryExecute(
			"select max(id) maxId from expense",
			[],
			{"datasource":this.dsn, "name":"rs"}
		);
		
		expVO.id = rs.maxId[1];
	}
	
	function getExpenses()
	{
		queryExecute("select * from expense order by expense_date desc",
			[],
			{"datasource":this.dsn, "name":"rs"});
		
		var result = [];
		if (rs.length == 0)
			return result;
		
		for (i = 1; i <= rs.length; i++)
		{
			var expVO = new ExpenseVO();
			expVO.id = rs.id[i];
			expVO.expenseDate = rs.expense_date[i];
			expVO.amount = rs.amount[i];
			expVO.description = rs.desc[i];
			result.append(expVO);
		}
		
		return result;
	}  
	
	function deleteAllExpenses()
	{
		queryExecute("delete from expense",[],{"datasource":this.dsn});
	}
}