using Microsoft.EntityFrameworkCore;
using WeBudgetWebAPI.Data;
using WeBudgetWebAPI.Interfaces;
using WeBudgetWebAPI.Models;
using WeBudgetWebAPI.Repository.Generics;

namespace WeBudgetWebAPI.Repository;

public class RepositoryTransaction: RepositoryGenerics<Transaction>, ITransaction
{
    private readonly DbContextOptions<IdentityDataContext> _OptionsBuilder;

    public RepositoryTransaction()
    {
        _OptionsBuilder = new DbContextOptions<IdentityDataContext>();
    }


    public async Task<List<Transaction>> ListByUser(string userId)
    {
        using (var data = new IdentityDataContext(_OptionsBuilder))
        {
            return await data.Set<Transaction>().Where(x => x.UserId == userId).ToListAsync();
        }
    }
}