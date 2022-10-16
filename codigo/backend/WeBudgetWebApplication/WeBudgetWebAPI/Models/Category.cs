using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.AspNetCore.Identity;

namespace WeBudgetWebAPI.Models;


[Table("Category")]
public class Category
{
    [Column("Id")]
    public int Id { get; set; }
    [Column("CategoryDescription")]
    public string Description { get; set; }
    
    [Column("CategoryIconCode")] 
    public int IconCode { get; set; }
    [ForeignKey("IdentityUser")]
    [Column(Order = 1)]
    public string UserId { get; set; }
    
    public virtual IdentityUser IdentityUser { get; set; }

}