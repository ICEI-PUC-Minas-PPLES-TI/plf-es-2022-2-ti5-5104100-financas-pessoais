using TestWeBudgetWebAPI.Mock;
using WeBudgetWebAPI.Interfaces;
using WeBudgetWebAPI.Interfaces.Sevices;
using WeBudgetWebAPI.Models;
using WeBudgetWebAPI.Models.Entities;
using WeBudgetWebAPI.Services;

namespace TestWeBudgetWebAPI.ServicesTest;

public class BudgetServiceTest
{
    private readonly BudgetService _budgetService;
    private readonly Mock<IBudget> _budgetMock;

    public BudgetServiceTest()
    {
        _budgetMock = BudgetMock.GetIBudgetMockInstance();
        var transactionMock = TransactionMock.GetITransactionMockInstance();
        var messageMock = new Mock<IMessageBrokerService<Budget>>();
        _budgetService = new BudgetService(_budgetMock.Object, messageMock.Object, transactionMock.Object);
    }

    [Fact]
    public async Task Add_ShouldReturnAReturnWithABudget()
    {
        //Arrange
        var budget = new Budget()
        {
            UserId = "0000-0000-0000-0000",
            BudgetDate = DateTime.Now,
            CategoryId = 1,
            BudgetValue = 1000.00,
            BudgetValueUsed = 0.0
        };
        TransactionMock.ReturnResultSum(budget.UserId, budget.BudgetDate, budget.CategoryId);
        BudgetMock.BudgetMockAddReturnResultOk();
        //Act
        var resultBudget = await _budgetService.Add(budget);
        //Assert
        Assert.True(resultBudget.Success);
        Assert.False(resultBudget.IsFailure);
        Assert.False(resultBudget.NotFound);
        Assert.Equal(0, resultBudget.Data!.Id);
    }
    [Fact]
    public async Task Add_ShouldReturnAReturnWithError()
    {
        //Arrange
        var budget = new Budget()
        {
            UserId = "0000-0000-0000-0000",
            BudgetDate = DateTime.Now,
            CategoryId = 1,
            BudgetValue = 1000.00,
            BudgetValueUsed = 0.0
        };
        TransactionMock.ReturnResultSum(budget.UserId, budget.BudgetDate, budget.CategoryId);
        BudgetMock.BudgetMockAddReturnResultFail();
        //Act
        var resultBudget = await _budgetService.Add(budget);
        //Assert
        Assert.False(resultBudget.Success);
        Assert.True(resultBudget.IsFailure);
        Assert.False(resultBudget.NotFound);
        Assert.Equal("Fail", resultBudget.ErrorMenssage);
    }
    [Fact]
    public async Task Update_ShouldReturnAReturnWithABudget()
    {
        //Arrange
        var budget = new Budget()
        {
            Id = 0,
            UserId = "0000-0000-0000-0000",
            BudgetDate = DateTime.Now,
            CategoryId = 1,
            BudgetValue = 1000.00,
            BudgetValueUsed = 0.0
        };
        BudgetMock.BudgetMockUpdateReturnResultOk();
        //Act
        var resultBudget = await _budgetService.Update(budget);
        //Assert
        Assert.True(resultBudget.Success);
        Assert.False(resultBudget.IsFailure);
        Assert.False(resultBudget.NotFound);
        Assert.Equal(0, resultBudget.Data!.Id);
    }
    [Fact]
    public async Task Update_ShouldReturnAReturnWithError()
    {
        //Arrange
        var budget = new Budget()
        {
            Id = 0,
            UserId = "0000-0000-0000-0000",
            BudgetDate = DateTime.Now,
            CategoryId = 1,
            BudgetValue = 1000.00,
            BudgetValueUsed = 0.0
        };
        BudgetMock.BudgetMockUpdateReturnResultFail();
        //Act
        var resultBudget = await _budgetService.Update(budget);
        //Assert
        Assert.False(resultBudget.Success);
        Assert.True(resultBudget.IsFailure);
        Assert.False(resultBudget.NotFound);
        Assert.Equal("Fail", resultBudget.ErrorMenssage);
    }
    [Fact]
    public async Task Delete_ShouldReturnAReturnWithSuccess()
    {
        //Arrange
        var budget = new Budget();
        BudgetMock.BudgetMockDeleteReturnResultOk();
        //Act
        var deleteResult = await _budgetService.Delete(budget);
        //Assert
        Assert.True(deleteResult.Success);
        Assert.False(deleteResult.IsFailure);
    }
    [Fact]
    public async Task Delete_ShouldReturnAReturnWithErrorMessage()
    {
        //Arrange
        var budget = new Budget();
        BudgetMock.BudgetMockDeleteReturnResultFail();
        //Act
        var deleteResult =  await _budgetService.Delete(budget);
        //Assert
        Assert.False(deleteResult.Success);
        Assert.True(deleteResult.IsFailure);
        Assert.Equal("Fail",
            deleteResult.ErrorMenssage);
    }
    [Fact]
    public async Task List_ShouldReturnAReturnWithBudgetList()
    {
        //Arrange
        _budgetMock.Setup(x => x.List())
            .ReturnsAsync(Result.Ok(BudgetMock.ReturnBudgetList(DateTime.Now)
                .ToList()));
        //Act
        var resultList = await _budgetService.List();
        //Assert
        Assert.True(resultList.Success);
        Assert.False(resultList.IsFailure);
        Assert.Equal(4, resultList.Data!.Count);
    }
    [Fact]
    public async Task List_ShouldReturnAReturnWithErrorMessage()
    {
        //Arrange
        _budgetMock.Setup(x => x.List())
            .ReturnsAsync(Result.Fail<List<Budget>>("Fail"));
        //Act
        var resultList = await _budgetService.List();
        //Assert
        Assert.False(resultList.Success);
        Assert.True(resultList.IsFailure);
        Assert.Equal("Fail",
            resultList.ErrorMenssage);
    }
    [Fact]
    public async Task ListByUser_ShouldReturnAReturnWithBudgetList()
    {
        //Arrange
        var datetime = DateTime.Now;
        var userId = "0000-0000-0000-0000";
        _budgetMock.Setup(x => x.ListByUser(userId))
            .ReturnsAsync(Result.Ok(BudgetMock.ReturnBudgetList(datetime)
                .Where(x=>x.UserId==userId).ToList()));
        //Act
        var resultList = await _budgetService.ListByUser(userId);
        //Assert
        Assert.True(resultList.Success);
        Assert.False(resultList.IsFailure);
        Assert.Equal(3, resultList.Data!.Count);
        Assert.True(resultList.Data!.All(x=>x.UserId==userId));
    }
    [Fact]
    public async Task ListByUser_ShouldReturnAReturnWithErrorMessage()
    {
        //Arrange
        var userId = "0000-0000-0000-0000";
        _budgetMock.Setup(x => x.ListByUser(userId))
            .ReturnsAsync(Result.Fail<List<Budget>>("Fail"));
        //Act
        var resultList = await _budgetService.ListByUser(userId);
        //Assert
        Assert.False(resultList.Success);
        Assert.True(resultList.IsFailure);
        Assert.Equal("Fail",
            resultList.ErrorMenssage);
    }
    [Fact]
    public async Task GetByUserAndTime_ShouldReturnAReturnWithBudget()
    {
        //Arrange
        var datetime = DateTime.Now;
        var userId = "0000-0000-0000-0000";
        var categoryId = 1;
        BudgetMock.BudgetMockGetByUserTimeAndCategoryReturnResultOk(userId,datetime,categoryId);
        //Act
        var resultBudget = await _budgetService.GetByUserTimeAndCategory(userId, datetime, categoryId);
        //Assert
        Assert.True(resultBudget.Success);
        Assert.False(resultBudget.IsFailure);
        Assert.Equal(userId, resultBudget.Data!.UserId);
        Assert.Equal(datetime.Month,
            resultBudget.Data!.BudgetDate.Month );
        Assert.Equal(datetime.Year,
            resultBudget.Data!.BudgetDate.Year );
    }
    [Fact]
    public async Task GetByUserAndTime_ShouldReturnAReturnWithErrorMessage()
    {
        //Arrange
        var datetime = DateTime.Now;
        var userId = "0000-0000-0000-0000";
        var categoryId = 1;
        BudgetMock.BudgetMockGetByUserTimeAndCategoryReturnResultFail(userId,datetime, categoryId);
        //Act
        var resultBudget = await _budgetService.GetByUserTimeAndCategory(userId, datetime,categoryId);
        //Assert
        Assert.False(resultBudget.Success);
        Assert.True(resultBudget.IsFailure);
        Assert.Equal("Fail",
            resultBudget.ErrorMenssage);
    }
    [Fact]
    public async Task GetByUserAndTime_ShouldReturnAReturnWithNotFound()
    {
        //Arrange
        var datetime = DateTime.Now;
        var userId = "0000-0000-0000-0000";
        var categoryId = 1;
        BudgetMock.BudgetMockGetByUserTimeAndCategoryReturnResultNotFound(userId,datetime, categoryId);
        //Act
        var resultBudget = await _budgetService.GetByUserTimeAndCategory(userId, datetime,categoryId);
        //Assert
        Assert.True(resultBudget.Success);
        Assert.False(resultBudget.IsFailure);
        Assert.True(resultBudget.NotFound);
    }
    [Fact]
    public async Task CreateRecurrentBudget_ShouldReturnAReturnWithBudget()
    {
        //Arrange
        var datetime = DateTime.Now;
        var userId = "0000-0000-0000-0000";
        var categoryId = 1;
        TransactionMock.ReturnResultSum(userId, datetime, categoryId);
        BudgetMock.BudgetMockGetByUserTimeAndCategoryReturnResultOk(userId, datetime.AddMonths(-1), categoryId);
        BudgetMock.BudgetMockAddReturnResultOk();
        //Act
        var resultBudget = await _budgetService.CreateRecurrentBudget(userId, datetime, categoryId);
        //Assert
        Assert.True(resultBudget.Success);
        Assert.False(resultBudget.IsFailure);
        Assert.False(resultBudget.NotFound);
        Assert.Equal(userId, resultBudget.Data!.UserId);
        Assert.Equal(datetime.Month,
            resultBudget.Data!.BudgetDate.Month );
        Assert.Equal(datetime.Year,
            resultBudget.Data!.BudgetDate.Year );
    }
    [Fact]
    public async Task CreateRecurrentBudget_ShouldReturnAReturnFail()
    {
        //Arrange
        var datetime = DateTime.Now;
        var userId = "0000-0000-0000-0000";
        var categoryId = 1;
        TransactionMock.ReturnResultSum(userId, datetime, categoryId);
        BudgetMock.BudgetMockGetByUserTimeAndCategoryReturnResultOk(userId, datetime.AddMonths(-1), categoryId);
        BudgetMock.BudgetMockAddReturnResultFail();
        //Act
        var resultBudget = await _budgetService.CreateRecurrentBudget(userId, datetime, categoryId);
        //Assert
        Assert.False(resultBudget.Success);
        Assert.True(resultBudget.IsFailure);
        Assert.False(resultBudget.NotFound);
        Assert.Equal("Fail", resultBudget.ErrorMenssage);
    }
    [Fact]
    public async Task UpdateUsedValue_ShouldReturnAReturnWithBudget()
    {
        //Arrange
        var datetime = DateTime.Now;
        var userId = "0000-0000-0000-0000";
        var categoryId = 1;
        var value = -100.00;
        TransactionMock.ReturnResultSum(userId, datetime, categoryId);
        BudgetMock.BudgetMockGetByUserTimeAndCategoryReturnResultOk(userId, datetime, categoryId);
        BudgetMock.BudgetMockAddReturnResultOk();
        BudgetMock.BudgetMockUpdateReturnResultOk();
        //Act
        var resultBudget = await _budgetService.UpdateUsedValue(userId, datetime,
            categoryId, value);
        //Assert
        Assert.True(resultBudget.Success);
        Assert.False(resultBudget.IsFailure);
        Assert.False(resultBudget.NotFound);
        Assert.Equal(userId, resultBudget.Data!.UserId);
        Assert.Equal(datetime.Month,
            resultBudget.Data!.BudgetDate.Month );
        Assert.Equal(datetime.Year,
            resultBudget.Data!.BudgetDate.Year );
        Assert.Equal(100.0, resultBudget.Data!.BudgetValueUsed);

    }
    [Fact]
    public async Task UpdateUsedValue_ShouldReturnAReturnWithFail()
    {
        //Arrange
        var datetime = DateTime.Now;
        var userId = "0000-0000-0000-0000";
        var categoryId = 1;
        var value = -100.00;
        TransactionMock.ReturnResultSum(userId, datetime, categoryId);
        BudgetMock.BudgetMockGetByUserTimeAndCategoryReturnResultOk(userId, datetime, categoryId);
        BudgetMock.BudgetMockAddReturnResultOk();
        BudgetMock.BudgetMockUpdateReturnResultFail();
        //Act
        var resultBudget = await _budgetService.UpdateUsedValue(userId, datetime,
            categoryId, value);
        //Assert
        Assert.False(resultBudget.Success);
        Assert.True(resultBudget.IsFailure);
        Assert.False(resultBudget.NotFound);
        Assert.Equal("Fail", resultBudget.ErrorMenssage);

    }
    [Fact]
    public async Task GetById_ShouldReturnAReturnWithBudget()
    {
        //Arrange
        var id = 0;
        BudgetMock.BudgetMockGetByIdResultOk(id);
        //Act
        var resultBudget = await _budgetService.GetEntityById(id);
        //Assert
        Assert.True(resultBudget.Success);
        Assert.False(resultBudget.IsFailure);
        Assert.Equal(id, resultBudget.Data!.Id);
    }
    [Fact]
    public async Task GetEntityById_ShouldReturnAReturnWithErrorMessage()
    {
        //Arrange
        var id = 0;
        BudgetMock.BudgetMockGetByIdResultError(id);
        //Act
        var resultBudget = await _budgetService.GetEntityById(id);
        //Assert
        Assert.False(resultBudget.Success);
        Assert.True(resultBudget.IsFailure);
        Assert.Equal("Fail",
            resultBudget.ErrorMenssage);
    }
    [Fact]
    public async Task GetEntityById_ShouldReturnAReturnWithNotFound()
    {
        //Arrange
        var id = 0;
        BudgetMock.BudgetMockGetByIdResultNotFound(id);
        //Act
        var resultBudget = await _budgetService.GetEntityById(id);
        //Assert
        Assert.True(resultBudget.Success);
        Assert.False(resultBudget.IsFailure);
        Assert.True(resultBudget.NotFound);
    }
    [Fact]
    public async Task ListByUserAndTime_ShouldReturnAReturnWithBudgetList()
    {
        //Arrange
        var datetime = DateTime.Now;
        var userId = "0000-0000-0000-0000";
        BudgetMock.BudgetMockListByUserTimeReturnResultOk(userId, datetime);
        
        //Act
        var resultList = await _budgetService.ListByUserAndTime(userId, datetime);
        //Assert
        Assert.True(resultList.Success);
        Assert.False(resultList.IsFailure);
        Assert.Single(resultList.Data!);
        Assert.True(resultList.Data!.All(x=>x.UserId==userId));
    }
    [Fact]
    public async Task ListByUserAndTime_ShouldReturnAReturnWithErrorMessage()
    {
        //Arrange
        var datetime = DateTime.Now;
        var userId = "0000-0000-0000-0000";
        BudgetMock.BudgetMockListByUserTimeReturnResultFail(userId, datetime);
        //Act
        var resultList = await _budgetService.ListByUserAndTime(userId, datetime);
        //Assert
        Assert.False(resultList.Success);
        Assert.True(resultList.IsFailure);
        Assert.Equal("Fail",
            resultList.ErrorMenssage);
    }

}