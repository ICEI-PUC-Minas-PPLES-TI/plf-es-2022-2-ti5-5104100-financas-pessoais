using WeBudgetWebAPI.Interfaces;
using WeBudgetWebAPI.Interfaces.Sevices;
using WeBudgetWebAPI.Models;

namespace WeBudgetWebAPI.Services;

public class BudgetService:IBudgetService
{
    private readonly IBudget _iBudget;

    public BudgetService(IBudget iBudget)
    {
        _iBudget = iBudget;
    }

    public async Task<Budget> UpdateUsedValue(string userId, DateTime dateTime,
        int categoryId, double value)
    {
        var savedBudget = await _iBudget
            .ListByUserTimeAndCategory(userId, dateTime, categoryId);
        if (savedBudget == null)
        {
            savedBudget = await CreateRecurrentBudget(userId, dateTime, categoryId);
            if (savedBudget == null)
                return null;
        }
        return savedBudget;
    }

    public async Task<Budget> CreateRecurrentBudget(string userId, DateTime dateTime, int categoryId)
    {
        var lastMonthBudget = await _iBudget
            .ListByUserTimeAndCategory(userId, dateTime.AddMonths(-1), categoryId);
        if (lastMonthBudget == null || lastMonthBudget.Active==false)
            return null;

        return await _iBudget.Add(new Budget()
        {
            UserId = userId,
            BudgetDate = dateTime,
            CategoryId = categoryId

        });

    }
    
}