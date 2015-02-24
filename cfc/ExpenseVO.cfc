component client="true"   
{
	this.id;
	this.expenseDate;
	this.amount;
	this.description;
	
	function init(expDate, amt, desc)
	{
		this.expenseDate = expDate;
		this.amount = amt;
		this.description = desc;
	}
}