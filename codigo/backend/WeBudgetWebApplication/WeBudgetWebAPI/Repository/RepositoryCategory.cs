using Microsoft.EntityFrameworkCore;
using WeBudgetWebAPI.Data;
using WeBudgetWebAPI.Interfaces;
using WeBudgetWebAPI.Models;
using WeBudgetWebAPI.Repository.Generics;

namespace WeBudgetWebAPI.Repository;

public class RepositoryCategory:RepositoryGenerics<Category>,ICategory
{
    private readonly DbContextOptions<IdentityDataContext> _OptionsBuilder;

    public RepositoryCategory()
    {
        _OptionsBuilder = new DbContextOptions<IdentityDataContext>();
    }
    public async Task<List<Category>> ListByUser(string userId)
    {
        using (var data = new IdentityDataContext(_OptionsBuilder))
        {
            return await data.Set<Category>().Where(x => x.UserId == userId).ToListAsync();
        }
    }
}