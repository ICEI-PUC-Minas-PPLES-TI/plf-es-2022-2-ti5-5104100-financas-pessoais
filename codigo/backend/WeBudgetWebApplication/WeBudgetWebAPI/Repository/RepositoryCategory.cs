using Microsoft.EntityFrameworkCore;
using WeBudgetWebAPI.Data;
using WeBudgetWebAPI.Interfaces;
using WeBudgetWebAPI.Models;
using WeBudgetWebAPI.Models.Entities;
using WeBudgetWebAPI.Repository.Generics;

namespace WeBudgetWebAPI.Repository;

public class RepositoryCategory:RepositoryGenerics<Category>,ICategory
{
    private readonly DbContextOptions<IdentityDataContext> _optionsBuilder;

    public RepositoryCategory()
    {
        _optionsBuilder = new DbContextOptions<IdentityDataContext>();
    }
    public async Task<Result<List<Category>>> ListByUser(string userId)
    {
        try
        {
            await using (var data = new IdentityDataContext(_optionsBuilder))
            {
                var entityList = await data.Set<Category>()
                    .Where(x => x.UserId == userId).ToListAsync();
                return Result.Ok(entityList);
            }
        }
        catch (Exception e)
        {
            return Result.Fail<List<Category>>(e.Message);
        }
    }
}