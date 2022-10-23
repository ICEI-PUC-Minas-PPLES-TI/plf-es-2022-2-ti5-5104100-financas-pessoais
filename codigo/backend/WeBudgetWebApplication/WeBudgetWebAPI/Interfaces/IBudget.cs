using WeBudgetWebAPI.Interfaces.Generics;
using WeBudgetWebAPI.Models;

namespace WeBudgetWebAPI.Interfaces;

public interface IBudget:IGeneric<Budget>
{
    public Task<List<Budget>> ListByUser(string userId);
    public Task<List<Budget>> ListByUserAndTime(string userId, DateTime dateTime);
    public Task<Budget> ListByUserTimeAndCategory(string userId, DateTime dateTime, int categoryId);
}