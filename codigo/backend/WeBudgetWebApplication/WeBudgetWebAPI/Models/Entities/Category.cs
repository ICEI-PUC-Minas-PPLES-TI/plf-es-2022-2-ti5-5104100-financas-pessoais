using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.AspNetCore.Identity;

namespace WeBudgetWebAPI.Models.Entities;


[Table("Category")]
public class Category
{
    [Column("Id")]
    public int Id { get; set; }
    [Column("CategoryDescription")]
    public string Description { get; set; }
    
    [Column("CategoryIconCode")] 
    public int IconCode { get; set; }
    [ForeignKey("ApplicationUser")]
    [Column(Order = 1)]
    public string UserId { get; set; }

    public virtual ApplicationUser ApplicationUser { get; set; }

}