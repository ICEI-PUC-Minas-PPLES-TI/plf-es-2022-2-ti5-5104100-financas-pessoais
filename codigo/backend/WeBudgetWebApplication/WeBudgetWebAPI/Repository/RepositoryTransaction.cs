using Microsoft.EntityFrameworkCore;
using WeBudgetWebAPI.Data;
using WeBudgetWebAPI.Interfaces;
using WeBudgetWebAPI.Models;
using WeBudgetWebAPI.Models.Entities;
using WeBudgetWebAPI.Models.Enums;
using WeBudgetWebAPI.Repository.Generics;

namespace WeBudgetWebAPI.Repository;

public class RepositoryTransaction: RepositoryGenerics<Transaction>, ITransaction
{
    private readonly DbContextOptions<IdentityDataContext> _optionsBuilder;

    public RepositoryTransaction()
    {
        _optionsBuilder = new DbContextOptions<IdentityDataContext>();
    }


    public async Task<Result<List<Transaction>>> ListByUser(string userId)
    {
        
        try
        {
            await using (var data = new IdentityDataContext(_optionsBuilder))
            {
                var entityList = await data.Set<Transaction>()
                    .Where(x => x.UserId == userId)
                    .Include(x=>x.Category)
                    .ToListAsync();
                return Result.Ok(entityList);
            }
        }
        catch (Exception e)
        {
            return Result.Fail<List<Transaction>>(e.Message);
        }
       
    }

    public async Task<Result<double>> SumTransaction(string userId, DateTime dateTime)
    {
        try
        {
            await using (var data = new IdentityDataContext(_optionsBuilder))
            {
                var sum = await data.Set<Transaction>()
                    .Where(x => x.UserId == userId
                                && x.TansactionDate.Month == dateTime.Month
                                && x.TansactionDate.Year == dateTime.Year)
                    .Select(x => x.TansactionType == TansactionType.Expenses ?
                        (-1 * x.PaymentValue) : x.PaymentValue)
                    .SumAsync();
                return Result.Ok(sum);
            }
        }
        catch (Exception e)
        {
            return Result.Fail<double>(e.Message);
        }
    }
}