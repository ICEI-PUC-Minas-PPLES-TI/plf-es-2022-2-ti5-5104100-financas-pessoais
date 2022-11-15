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
            IConfigurationRoot configuration = new ConfigurationBuilder()
                .SetBasePath(AppDomain.CurrentDomain.BaseDirectory)
                .AddJsonFile("appsettings.json")
                .Build();
            optionsBuilder.UseSqlServer(
                configuration.GetConnectionString("Default"));
        }
    }

    public DbSet<Transaction> Transaction { get; set; }
    public DbSet<Budget> Budget { get; set; }
    public DbSet<Category> Category { get; set; }
    public DbSet<Account> Account { get; set; }
}