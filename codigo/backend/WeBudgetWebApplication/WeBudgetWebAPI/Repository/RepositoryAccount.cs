using Microsoft.EntityFrameworkCore;
using WeBudgetWebAPI.Data;
using WeBudgetWebAPI.Interfaces;
using WeBudgetWebAPI.Models;
using WeBudgetWebAPI.Models.Entities;
using WeBudgetWebAPI.Repository.Generics;

namespace WeBudgetWebAPI.Repository;

public class RepositoryAccount:RepositoryGenerics<Account>,IAccount
{
    private readonly DbContextOptions<IdentityDataContext> _optionsBuilder;
    public RepositoryAccount()
    {
        _optionsBuilder = new DbContextOptions<IdentityDataContext>();
    }

    public async Task<Result<List<Account>>> ListByUser(string userId)
    {
        try
        {
            await using (var data = new IdentityDataContext(_optionsBuilder))
            {
                var entityList = await data.Set<Account>()
                    .Where(x => x.UserId == userId)
                    .ToListAsync();
                return Result.Ok<List<Account>>(entityList);
            }
        }
        catch (Exception e)
        {
            return Result.Fail<List<Account>>(e.Message);
        }
        
    }

    public async Task<Result<Account>> GetByUserAndTime(string userId, DateTime dateTime)
    {
        try
        {
            await using (var data = new IdentityDataContext(_optionsBuilder))
            {
                var entity = await data.Set<Account>()
                    .Where(x => x.UserId == userId 
                                && x.AccountDateTime.Month == dateTime.Month 
                                && x.AccountDateTime.Year == dateTime.Year)
                    .FirstOrDefaultAsync();
                return entity == null ? 
                    Result.NotFound<Account>() : Result.Ok(entity);
            }
        }
        catch (Exception e)
        {
            return Result.Fail<Account>(e.Message);
        }
        
    }
    
}