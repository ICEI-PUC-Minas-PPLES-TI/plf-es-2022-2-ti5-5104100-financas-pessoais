using WeBudgetWebAPI.Interfaces;
using WeBudgetWebAPI.Models;
using WeBudgetWebAPI.Models.Entities;

namespace TestWeBudgetWebAPI.Mock;

public static class BudgetMock
{
    private static Mock<IBudget>? _budgetMock;
    public static Mock<IBudget> GetIBudgetMockInstance()
    {
        return _budgetMock ??= new Mock<IBudget>();
    }
    public static void BudgetMockAddReturnResultOk()
    {
        if (_budgetMock != null)
            _budgetMock.Setup(x => x.Add(It.IsAny<Budget>()))
                .ReturnsAsync((Budget x) =>
                {
                    x.Id = 0;
                    return Result.Ok(x);
                });
    }
    public static void BudgetMockAddReturnResultFail()
    {
        if (_budgetMock != null)
            _budgetMock.Setup(x => x.Add(It.IsAny<Budget>()))
                .ReturnsAsync(Result.Fail<Budget>("Fail"));
    }
    public static void BudgetMockUpdateReturnResultOk()
    {
        if (_budgetMock != null)
            _budgetMock.Setup(x => x.Update(It.IsAny<Budget>()))
                .ReturnsAsync((Budget x) => Result.Ok(x));
    }
    public static void BudgetMockUpdateReturnResultFail()
    {
        if (_budgetMock != null)
            _budgetMock.Setup(x => x.Update(It.IsAny<Budget>()))
                .ReturnsAsync(Result.Fail<Budget>("Fail"));
    }
    public static void BudgetMockDeleteReturnResultOk()
    {
        if (_budgetMock != null)
            _budgetMock.Setup(x => x.Delete(It.IsAny<Budget>()))
                .ReturnsAsync(Result.Ok());
    }
    public static void BudgetMockDeleteReturnResultFail()
    {
        if (_budgetMock != null)
            _budgetMock.Setup(x => x.Delete(It.IsAny<Budget>()))
                .ReturnsAsync(Result.Fail("Fail"));
    }
    public static void BudgetMockGetByUserTimeAndCategoryReturnResultOk(string userId, DateTime datetime, int categoryId)
    {
        if (_budgetMock != null)
            _budgetMock.Setup(x => x.GetByUserTimeAndCategory(userId, datetime, categoryId))
                .ReturnsAsync(Result.Ok(ReturnBudgetList(datetime).First(x =>
                    x.UserId == userId && x.BudgetDate.Month == datetime.Month
                                       && x.BudgetDate.Year == datetime.Year
                                       && x.CategoryId==categoryId)));
    }
    public static void BudgetMockGetByUserTimeAndCategoryReturnResultNotFound(string userId, DateTime datetime, int categoryId)
    {
        if (_budgetMock != null)
            _budgetMock.Setup(x => x.GetByUserTimeAndCategory(userId, datetime, categoryId))
                .ReturnsAsync(Result.NotFound<Budget>());
    }
    public static void BudgetMockGetByUserTimeAndCategoryReturnResultFail(string userId, DateTime datetime, int categoryId)
    {
        if (_budgetMock != null)
            _budgetMock.Setup(x => x.GetByUserTimeAndCategory(userId, datetime, categoryId))
                .ReturnsAsync(Result.Fail<Budget>("Fail"));
    }
    public static void BudgetMockGetByIdResultOk(int id)
    {
        if (_budgetMock != null)
            _budgetMock.Setup(x => x.GetEntityById(id))
                .ReturnsAsync(Result.Ok(ReturnBudgetList(DateTime.Now).First(x =>
                    x.Id == id)));
    }
    public static void BudgetMockGetByIdResultError(int id)
    {
        if (_budgetMock != null)
            _budgetMock.Setup(x => x.GetEntityById(id))
                .ReturnsAsync(Result.Fail<Budget>("Fail"));
    }
    public static void BudgetMockGetByIdResultNotFound(int id)
    {
        if (_budgetMock != null)
            _budgetMock.Setup(x => x.GetEntityById(id))
                .ReturnsAsync(Result.NotFound<Budget>());
    }
    public static void BudgetMockListByUserTimeReturnResultOk(string userId, DateTime datetime)
    {
        if (_budgetMock != null) 
            _budgetMock.Setup(x => x.ListByUserAndTime(userId,datetime))
                .ReturnsAsync(Result.Ok(BudgetMock.ReturnBudgetList(datetime)
                    .Where(x=>x.UserId==userId 
                              && x.BudgetDate.Month == datetime.Month
                              && x.BudgetDate.Year == datetime.Year)
                    .ToList()));
    }

    public static void BudgetMockListByUserTimeReturnResultFail(string userId, DateTime datetime)
    {
        if (_budgetMock != null)
            _budgetMock.Setup(x => x.ListByUserAndTime(userId,datetime))
                .ReturnsAsync(Result.Fail<List<Budget>>("Fail"));

    }
    public static IEnumerable<Budget> ReturnBudgetList(DateTime datetime)
    {

        return new List<Budget>()
        {
            new Budget()
            {
                Id = 0,
                UserId = "0000-0000-0000-0000",
                BudgetDate = datetime,
                Active = true,
                CategoryId = 1,
                BudgetValue = 1000.0,
                BudgetValueUsed = 0.0
                
            },
            new Budget()
            {
                Id = 1,
                UserId = "0000-0000-0000-0000",
                BudgetDate = datetime.AddMonths(-2),
                Active = true,
                CategoryId = 1,
                BudgetValue = 1000.0,
                BudgetValueUsed = 0.0
                
            },
            new Budget()
            {
                Id = 2,
                UserId = "0000-0000-0000-0000",
                BudgetDate = datetime.AddMonths(-1),
                Active = true,
                CategoryId = 1,
                BudgetValue = 1000.0,
                BudgetValueUsed = 0.0
            },
            new Budget()
            {
                Id = 3,
                UserId = "0000-0000-0000-0001",
                BudgetDate = datetime,
                Active = true,
                CategoryId = 2,
                BudgetValue = 1000.0,
                BudgetValueUsed = 0.0
            }
        };
    }

    
}