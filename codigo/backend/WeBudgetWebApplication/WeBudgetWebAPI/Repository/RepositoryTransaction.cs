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


    public async Task<List<Transaction>> ListByUser(string userId)
    {
        using (var data = new IdentityDataContext(_optionsBuilder))
        {
            return await data.Set<Transaction>()
                .Where(x => x.UserId == userId)
                .Include(x=>x.Category)
                .ToListAsync();
        }
    }

    public async Task<double> SumTransaction(string userId, DateTime dateTime)
    {
        using (var data = new IdentityDataContext(_optionsBuilder))
        {
            return await data.Set<Transaction>()
                .Where(x => x.UserId == userId
                            && x.TansactionDate.Month == dateTime.Month
                            && x.TansactionDate.Year == dateTime.Year)
                .Select(x => x.TansactionType == TansactionType.Expenses ?
                    (-1 * x.PaymentValue) : x.PaymentValue)
                .SumAsync();


        }
    }
}