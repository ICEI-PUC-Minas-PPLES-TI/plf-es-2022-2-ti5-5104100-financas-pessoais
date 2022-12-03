using WeBudgetWebAPI.Interfaces.Sevices;
using WeBudgetWebAPI.Models;
using WeBudgetWebAPI.Models.Entities;

namespace TestWeBudgetWebAPI.Mock;

public class BudgetServiceMock
{
    private static Mock<IBudgetService>? _budgetServiceMock;
    public static Mock<IBudgetService> GetIBudgetServiceMockInstance()
    {
        return _budgetServiceMock ??= new Mock<IBudgetService>();
    }
    public static void UpdateValueReturnResultWithBudget(DateTime dateTime, double value,
        string userId, int categoryId)
    {
        var budget = new Budget()
        {
            Id = 0,
            UserId = userId,
            CategoryId = categoryId,
            BudgetValue = 1000,
            BudgetValueUsed = -value,
            BudgetDate = dateTime
        };
        if(_budgetServiceMock!=null) 
            _budgetServiceMock.Setup(x => x.UpdateUsedValue(userId,dateTime,
                    categoryId,value))
                .ReturnsAsync(Result.Ok(budget));
    }
}