using WeBudgetWebAPI.Interfaces.Generics;
using WeBudgetWebAPI.Models;
using WeBudgetWebAPI.Models.Entities;

namespace WeBudgetWebAPI.Interfaces;

public interface IBudget:IGeneric<Budget>
{
    public Task<Result<List<Budget>>> ListByUser(string userId);
    public Task<Result<List<Budget>>> ListByUserAndTime(string userId, DateTime dateTime);
    public Task<Result<Budget>> GetByUserTimeAndCategory(string userId, DateTime dateTime, int categoryId);
}