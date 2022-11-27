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


    public async Task<Result<List<Budget>>> ListByUser(string userId)
    {
        try
        {
            await using (var data = new IdentityDataContext(_optionsptionsBuilder))
            {
                var entityList =  await data.Set<Budget>()
                    .Where(x => x.UserId == userId).ToListAsync();
                return Result.Ok(entityList);
            }
        }
        catch (Exception e)
        {
            return Result.Fail<List<Budget>>(e.Message);
        }
        
    }

    public async Task<Result<List<Budget>>> ListByUserAndTime(string userId, DateTime dateTime)
    {
        try
        {
            await using (var data = new IdentityDataContext(_optionsptionsBuilder))
            {
                var entityList =  await data.Set<Budget>()
                    .Where(x => x.UserId == userId
                                && x.BudgetDate.Month == dateTime.Month
                                && x.BudgetDate.Year == dateTime.Year)
                    .ToListAsync();
                return Result.Ok(entityList);
            }
        }
        catch (Exception e)
        {
            return Result.Fail<List<Budget>>(e.Message);
        }
    }

    public async Task<Result<Budget>> GetByUserTimeAndCategory(string userId, DateTime dateTime, int categoryId)
    {
      
        try
        {
            await using (var data = new IdentityDataContext(_optionsptionsBuilder))
            {
                var entity =  await data.Set<Budget>()
                    .Where(x => x.UserId == userId
                                && x.BudgetDate.Month == dateTime.Month
                                && x.BudgetDate.Year == dateTime.Year
                                && x.CategoryId == categoryId)
                    .FirstOrDefaultAsync();
                return entity == null ? 
                    Result.NotFound<Budget>() : Result.Ok(entity);
            }
        }
        catch (Exception e)
        {
            return Result.Fail<Budget>(e.Message);
        }
    }
}