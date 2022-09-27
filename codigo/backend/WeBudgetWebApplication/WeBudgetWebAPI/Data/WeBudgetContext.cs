using Microsoft.EntityFrameworkCore;
using WeBudgetWebAPI.Models;

namespace WeBudgetWebAPI.Data;

public class WeBudgetContext:DbContext
{
    public WeBudgetContext(DbContextOptions<WeBudgetContext> options) : base(options)
    {
    }
    
    public DbSet<User> Users { get; set; }
}