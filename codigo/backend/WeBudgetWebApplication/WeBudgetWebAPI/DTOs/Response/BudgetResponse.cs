namespace WeBudgetWebAPI.DTOs.Response;

public class BudgetResponse
{
        public int Id { get; set; }
        public double BudgetValue { get; set; }
        public double BudgetValueUsed { get; set; }
        public DateTime BudgetDate{ get; set; }
        public bool Active{ get; set; }
        public int CategoryId { get; set; }
        public string UserId { get; set; }
}