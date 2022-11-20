using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.AspNetCore.Identity;

namespace WeBudgetWebAPI.Models.Entities;

public class ApplicationUser:IdentityUser
{
    [Column("FirstName")]
    public string FirstName { get; set; }
    [Column("LastName")]
    public string LastName { get; set; }
}