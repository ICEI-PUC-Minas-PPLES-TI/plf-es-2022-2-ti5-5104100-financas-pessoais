using System.ComponentModel.DataAnnotations.Schema;

namespace WeBudgetWebAPI.Models.Entities;


[Table("Account")]
public class Account
{
    [Column("Id")]
    public int Id { get; set; }
    [Column("AccountBalance")]
    public double AccountBalance { get; set; }
    [Column("AccountDateTime")]
    public DateTime AccountDateTime{ get; set; }
    [ForeignKey("ApplicationUser")]
    [Column(Order = 1)]
    public string UserId { get; set; }

    public virtual ApplicationUser ApplicationUser { get; set; }
}