using WeBudgetWebAPI.Interfaces.Generics;
using WeBudgetWebAPI.Models;
using WeBudgetWebAPI.Models.Entities;

namespace WeBudgetWebAPI.Interfaces;

public interface IBudget:IGeneric<Budget>
{
    public Task<List<Budget>> ListByUser(string userId);
    public Task<List<Budget>> ListByUserAndTime(string userId, DateTime dateTime);
    public Task<Budget?> GetByUserTimeAndCategory(string userId, DateTime dateTime, int categoryId);
}