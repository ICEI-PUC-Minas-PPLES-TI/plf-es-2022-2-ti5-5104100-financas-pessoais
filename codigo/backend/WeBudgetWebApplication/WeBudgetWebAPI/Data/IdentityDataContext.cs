using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using WeBudgetWebAPI.Models;

namespace WeBudgetWebAPI.Data;

public class IdentityDataContext:IdentityDbContext
{
    public IdentityDataContext(DbContextOptions<IdentityDataContext> options) : base(options) { }
    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    {
        if (!optionsBuilder.IsConfigured)
        {
            optionsBuilder.UseNpgsql(
                "User Id=slxgrvnf; Password=2P6_Lc4w4WlNY8hLvz7-dgNWCEplYfr_; Host=jelani.db.elephantsql.com; Port=; Database=slxgrvnf;");
        }
    }

    public DbSet<Transaction> Transaction { get; set; }
    public DbSet<Budget> Budget { get; set; }
    public DbSet<Category> Category { get; set; }
    public DbSet<Account> Account { get; set; }
}