using Microsoft.EntityFrameworkCore;
using WeBudgetWebAPI.Data;
using WeBudgetWebAPI.Interfaces;
using WeBudgetWebAPI.Models;
using WeBudgetWebAPI.Repository.Generics;

namespace WeBudgetWebAPI.Repository;

public class RepositoryBudget:RepositoryGenerics<Budget>,IBudget
{
    private readonly DbContextOptions<IdentityDataContext> _OptionsBuilder;

    public RepositoryBudget()
    {
        _OptionsBuilder = new DbContextOptions<IdentityDataContext>();
    }


    public async Task<List<Budget>> ListByUser(string userId)
    {
        using (var data = new IdentityDataContext(_OptionsBuilder))
        {
            return await data.Set<Budget>().Where(x => x.UserId == userId).ToListAsync();
        }
    }
}