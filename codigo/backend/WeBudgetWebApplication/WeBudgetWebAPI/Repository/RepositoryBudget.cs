using Microsoft.EntityFrameworkCore;
using WeBudgetWebAPI.Data;
using WeBudgetWebAPI.Interfaces;
using WeBudgetWebAPI.Models;
using WeBudgetWebAPI.Models.Entities;
using WeBudgetWebAPI.Repository.Generics;

namespace WeBudgetWebAPI.Repository;

public class RepositoryBudget:RepositoryGenerics<Budget>,IBudget
{
    private readonly DbContextOptions<IdentityDataContext> _optionsptionsBuilder;

    public RepositoryBudget()
    {
        _optionsptionsBuilder = new DbContextOptions<IdentityDataContext>();
    }


    public async Task<List<Budget>> ListByUser(string userId)
    {
        using (var data = new IdentityDataContext(_optionsptionsBuilder))
        {
            return await data.Set<Budget>().Where(x => x.UserId == userId).ToListAsync();
        }
    }

    public async Task<List<Budget>> ListByUserAndTime(string userId, DateTime dateTime)
    {
        using (var data = new IdentityDataContext(_optionsptionsBuilder))
        {
            return await data.Set<Budget>()
                .Where(x => x.UserId == userId
                            && x.BudgetDate.Month == dateTime.Month
                            && x.BudgetDate.Year == dateTime.Year)
                .ToListAsync();
        }
    }

    public async Task<Budget?> GetByUserTimeAndCategory(string userId, DateTime dateTime, int categoryId)
    {
        using (var data = new IdentityDataContext(_optionsptionsBuilder))
        {
            return await data.Set<Budget>()
                .Where(x => x.UserId == userId
                            && x.BudgetDate.Month == dateTime.Month
                            && x.BudgetDate.Year == dateTime.Year
                            && x.CategoryId == categoryId)
                .FirstOrDefaultAsync();;
        }
    }
}