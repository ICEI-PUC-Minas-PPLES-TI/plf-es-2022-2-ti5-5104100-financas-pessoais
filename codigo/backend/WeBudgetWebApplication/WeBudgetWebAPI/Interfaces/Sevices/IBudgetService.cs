using WeBudgetWebAPI.Models;
using WeBudgetWebAPI.Models.Entities;

namespace WeBudgetWebAPI.Interfaces.Sevices;

public interface IBudgetService:IBudget
{
    Task<Result<Budget>> UpdateUsedValue(string userId, DateTime dateTime, int categoryId, double value);
    Task<Result<Budget>> CreateRecurrentBudget(string userId, DateTime dateTime, int categoryId);
}