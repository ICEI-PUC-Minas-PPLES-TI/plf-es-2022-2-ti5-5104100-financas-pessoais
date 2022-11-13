using WeBudgetWebAPI.Models;

namespace WeBudgetWebAPI.Interfaces.Sevices;

public interface IBudgetService:IBudget
{
    Task<Budget?> UpdateUsedValue(string userId, DateTime dateTime, int categoryId, double value);
    Task<Budget?> CreateRecurrentBudget(string userId, DateTime dateTime, int categoryId);
}