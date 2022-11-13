using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.AspNetCore.Identity;

namespace WeBudgetWebAPI.Models;


[Table("Account")]
public class Account
{
    [Column("Id")]
    public int Id { get; set; }
    [Column("AccountBalance")]
    public double AccountBalance { get; set; }
    [Column("AccountDateTime")]
    public DateTime AccountDateTime{ get; set; }
    [ForeignKey("IdentityUser")]
    [Column(Order = 1)]
    public string UserId { get; set; }
    
    public virtual IdentityUser IdentityUser { get; set; }
}