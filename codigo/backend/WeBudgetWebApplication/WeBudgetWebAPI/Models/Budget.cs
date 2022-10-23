using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.AspNetCore.Identity;

namespace WeBudgetWebAPI.Models;


[Table("Budget")]
public class Budget
{
    [Column("Id")]
    public int Id { get; set; }
    [Column("BudgetValue")]
    public double BudgetValue { get; set; }
    [Column("BudgetValueUsed")]
    public double BudgetValueUsed { get; set; }
    [Column("BudgetDate")]
    public DateTime BudgetDate{ get; set; }
    [Column("Active")]
    public bool Active{ get; set; }
    [ForeignKey("Category")]
    public int CategoryId { get; set; }
    
    public virtual Category Category { get; set; }
    
    [ForeignKey("IdentityUser")]
    [Column(Order = 1)]
    public string UserId { get; set; }
    
    public virtual IdentityUser IdentityUser { get; set; }
}