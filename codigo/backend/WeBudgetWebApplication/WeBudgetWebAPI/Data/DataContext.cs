using Microsoft.EntityFrameworkCore;

namespace WeBudgetWebAPI.Data;

public class DataContext:DbContext
{
    public DataContext(DbContextOptions<DataContext> options) : base(options) { }
    
}