using Microsoft.EntityFrameworkCore;
using WeBudgetWebAPI.Data;
using WeBudgetWebAPI.Interfaces;
using WeBudgetWebAPI.Models;
using WeBudgetWebAPI.Repository.Generics;

namespace WeBudgetWebAPI.Repository;

public class RepositoryAccount:RepositoryGenerics<Account>,IAccount
{
    private readonly DbContextOptions<IdentityDataContext> _OptionsBuilder;
    public RepositoryAccount()
    {
        _OptionsBuilder = new DbContextOptions<IdentityDataContext>();
    }

    public async Task<List<Account>> ListByUser(string userId)
    {
        using (var data = new IdentityDataContext(_OptionsBuilder))
        {
            return await data.Set<Account>().Where(x => x.UserId == userId).ToListAsync();
        }
    }

    public async Task<Account> ListByUserAndTime(string userId, DateTime dateTime)
    {
        using (var data = new IdentityDataContext(_OptionsBuilder))
        {
            return await data.Set<Account>().Where(x => x.UserId == userId 
                   && x.AccountDateTime.Month == dateTime.Month
                   && x.AccountDateTime.Year == dateTime.Year).FirstAsync();
        }
    }
    
}