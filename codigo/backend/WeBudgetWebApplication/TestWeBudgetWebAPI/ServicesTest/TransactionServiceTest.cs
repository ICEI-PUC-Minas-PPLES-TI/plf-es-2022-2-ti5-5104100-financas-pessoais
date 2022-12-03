using TestWeBudgetWebAPI.Mock;
using WeBudgetWebAPI.Interfaces.Sevices;
using WeBudgetWebAPI.Models.Entities;
using WeBudgetWebAPI.Models.Enums;
using WeBudgetWebAPI.Services;

namespace TestWeBudgetWebAPI.ServicesTest;

public class TransactionServiceTest
{
    private readonly TransactionService _transactionService;
    
    
    public TransactionServiceTest()
    {
        var messageMock = new Mock<IMessageBrokerService<Transaction>>();
        var transactionMock = TransactionMock.GetITransactionMockInstance();
        var budgetServiceMock = BudgetServiceMock.GetIBudgetServiceMockInstance();
        var accountServiceMock = AccountServiceMock.GetIAccountServiceMockInstance();
        _transactionService = new TransactionService(transactionMock.Object, accountServiceMock.Object,
            budgetServiceMock.Object, messageMock.Object);
    }
    [Fact]
    public async Task Add_ShouldReturnResultWithAnAccount()
    {
        //Arrange
        var transaction = new Transaction()
        {
           UserId = "0000-0000-0000-0000",
           Address = "5th avenue",
           Latitude = 0.0,
           Longitude = 0.0,
           Description = "Tax",
           CategoryId = 0,
           TansactionDate = DateTime.Now,
           PaymentValue = 100.00,
           TansactionType = TansactionType.Expenses,
           PaymentType = "credit"

        };
        var value = transaction.TansactionType == TansactionType.Expenses?
            -transaction.PaymentValue:transaction.PaymentValue;
        UpdateValueSetup(transaction, value);
        TransactionMock.AddReturnResultOk();
        //Act
        var resulTransaction = await _transactionService.Add(transaction);
        //Assert
        Assert.True(resulTransaction.Success);
        Assert.False(resulTransaction.IsFailure);
        Assert.False(resulTransaction.NotFound);
        Assert.Equal(0, resulTransaction.Data!.Id);
    }
    [Fact]
    public async Task Add_ShouldRReturnResultWithError()
    {
        //Arrange
        var transaction = new Transaction()
        {
            UserId = "0000-0000-0000-0000",
            Address = "5th avenue",
            Latitude = 0.0,
            Longitude = 0.0,
            Description = "Tax",
            CategoryId = 0,
            TansactionDate = DateTime.Now,
            PaymentValue = 100.00,
            TansactionType = TansactionType.Expenses,
            PaymentType = "credit"

        };
        TransactionMock.AddReturnResultFail();
        //Act
        var resulTransaction = await _transactionService.Add(transaction);
        //Assert
        Assert.False(resulTransaction.Success);
        Assert.True(resulTransaction.IsFailure);
        Assert.False(resulTransaction.NotFound);
        Assert.Equal("Fail", resulTransaction.ErrorMenssage);
    }
    [Fact]
    public async Task Update_ShouldReturnResultWithTransactionExpenses()
    {
        //Arrange
        var value = 0;
        var transaction = new Transaction()
        {
            Id = 0,
            UserId = "0000-0000-0000-0000",
            Address = "5th avenue",
            Latitude = 0.0,
            Longitude = 0.0,
            Description = "Tax",
            CategoryId = 0,
            TansactionDate = DateTime.Now,
            PaymentValue = 100.00,
            TansactionType = TansactionType.Expenses,
            PaymentType = "credit"

        };
        UpdateValueSetup(transaction, value);
        TransactionMock.GetEntityByIdReturnResultOk(transaction.Id);
        TransactionMock.UpdateReturnResultOk();
        //Act
        var resulTransaction = await _transactionService.Update(transaction);
        //Assert
        Assert.True(resulTransaction.Success);
        Assert.False(resulTransaction.IsFailure);
        Assert.False(resulTransaction.NotFound);
        Assert.Equal(0, resulTransaction.Data!.Id);
    }
    [Fact]
    public async Task Update_ShouldReturnResultWithTransactionIncoming()
    {
        //Arrange
        var value = 200;
        var transaction = new Transaction()
        {
            Id = 0,
            UserId = "0000-0000-0000-0000",
            Address = "5th avenue",
            Latitude = 0.0,
            Longitude = 0.0,
            Description = "Tax",
            CategoryId = 0,
            TansactionDate = DateTime.Now,
            PaymentValue = 100.00,
            TansactionType = TansactionType.Incoming,
            PaymentType = "credit"

        };
        UpdateValueSetup(transaction, value);
        TransactionMock.GetEntityByIdReturnResultOk(transaction.Id);
        TransactionMock.UpdateReturnResultOk();
        //Act
        var resulTransaction = await _transactionService.Update(transaction);
        //Assert
        Assert.True(resulTransaction.Success);
        Assert.False(resulTransaction.IsFailure);
        Assert.False(resulTransaction.NotFound);
        Assert.Equal(0, resulTransaction.Data!.Id);
    }
    [Fact]
    public async Task Update_ShouldReturnAReturnWithError()
    {
        //Arrange
        var transaction = new Transaction()
        {
            Id = 0,
            UserId = "0000-0000-0000-0000",
            Address = "5th avenue",
            Latitude = 0.0,
            Longitude = 0.0,
            Description = "Tax",
            CategoryId = 0,
            TansactionDate = DateTime.Now,
            PaymentValue = 100.00,
            TansactionType = TansactionType.Expenses,
            PaymentType = "credit"

        };
        var value = transaction.TansactionType == TansactionType.Expenses?
            -transaction.PaymentValue:transaction.PaymentValue;
        UpdateValueSetup(transaction, value);
        TransactionMock.GetEntityByIdReturnResultOk(transaction.Id);
        TransactionMock.UpdateReturnResultFail();
        //Act
        var resulTransaction = await _transactionService.Update(transaction);
        //Assert
        Assert.False(resulTransaction.Success);
        Assert.True(resulTransaction.IsFailure);
        Assert.False(resulTransaction.NotFound);
        Assert.Equal("Fail",
            resulTransaction.ErrorMenssage);
    }
    [Fact]
    public async Task Delete_ShouldReturnAReturnWithSuccess()
    {
        //Arrange
        var transaction = new Transaction()
        {
            Id = 0,
            UserId = "0000-0000-0000-0000",
            Address = "5th avenue",
            Latitude = 0.0,
            Longitude = 0.0,
            Description = "Tax",
            CategoryId = 0,
            TansactionDate = DateTime.Now,
            PaymentValue = 100.00,
            TansactionType = TansactionType.Expenses,
            PaymentType = "credit"

        };
        var value = 100;
        UpdateValueSetup(transaction,value);
        TransactionMock.DeleteReturnResultOk();
        //Act
        var deleteResult = await _transactionService.Delete(transaction);
        //Assert
        Assert.True(deleteResult.Success);
        Assert.False(deleteResult.IsFailure);
    }
    [Fact]
    public async Task Delete_ShouldReturnAReturnWithErrorMessage()
    {
        //Arrange
        var transaction = new Transaction();
        TransactionMock.DeleteReturnResultError();
        //Act
        var deleteResult = await _transactionService.Delete(transaction);
        //Assert
        Assert.False(deleteResult.Success);
        Assert.True(deleteResult.IsFailure);
        Assert.Equal("Fail",
            deleteResult.ErrorMenssage);
    }
    [Fact]
    public async Task List_ShouldReturnAReturnWithTransactionList()
    {
        //Arrange
        TransactionMock.ListReturnResultOk();
        //Act
        var resultList = await _transactionService.List();
        //Assert
        Assert.True(resultList.Success);
        Assert.False(resultList.IsFailure);
        Assert.Equal(4, resultList.Data!.Count);
    }
    [Fact]
    public async Task List_ShouldReturnAReturnWithErrorMessage()
    {
        //Arrange
        TransactionMock.ListReturnResultFail();
        //Act
        var resultList = await _transactionService.List();
        //Assert
        Assert.False(resultList.Success);
        Assert.True(resultList.IsFailure);
        Assert.Equal("Fail",
            resultList.ErrorMenssage);
    }
    [Fact]
    public async Task GetById_ShouldReturnAReturnWithTransaction()
    {
        //Arrange
        var id = 0;
        TransactionMock.GetEntityByIdReturnResultOk(id);
        //Act
        var resultTransaction = await _transactionService.GetEntityById(id);
        //Assert
        Assert.True(resultTransaction.Success);
        Assert.False(resultTransaction.IsFailure);
        Assert.Equal(id, resultTransaction.Data!.Id);
    }
    [Fact]
    public async Task GetById_ShouldReturnAReturnWithErrorMessage()
    {
        //Arrange
        var id = 0;
        TransactionMock.GetEntityByIdReturnResultFail(id);
        //Act
        var resultTransaction = await _transactionService.GetEntityById(id);
        //Assert
        Assert.False(resultTransaction.Success);
        Assert.True(resultTransaction.IsFailure);
        Assert.Equal("Fail",
            resultTransaction.ErrorMenssage);
    }
    [Fact]
    public async Task GetById_ShouldReturnAReturnWithNotFound()
    {
        //Arrange
        var id = 0;
        TransactionMock.GetEntityByIdReturnResultNotFound(id);
        //Act
        var resultTransaction = await _transactionService.GetEntityById(id);
        //Assert
        Assert.True(resultTransaction.Success);
        Assert.False(resultTransaction.IsFailure);
        Assert.True(resultTransaction.NotFound);
    }
    [Fact]
    public async Task ListByUser_ShouldReturnAReturnWithTransactionList()
    {
        //Arrange
        var userId = "0000-0000-0000-0000";
        TransactionMock.ListByUserReturnResultOk(userId);
        //Act
        var resultList = await _transactionService.ListByUser(userId);
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
        TransactionMock.ListByUserReturnResultFail(userId);
        //Act
        var resultList = await _transactionService.ListByUser(userId);
        //Assert
        Assert.False(resultList.Success);
        Assert.True(resultList.IsFailure);
        Assert.Equal("Fail",
            resultList.ErrorMenssage);
    }
    [Fact]
    public async Task SumTransaction_ShouldReturnAReturnWithErrorMessage()
    {
        //Arrange
        var userId = "0000-0000-0000-0000";
        var categoryId = 1;
        var datetime = DateTime.Now;
        TransactionMock.ReturnResultSum(userId,datetime,categoryId);
        //Act
        var resultList = await _transactionService.SumTransaction(userId,datetime,categoryId);
        //Assert
        Assert.True(resultList.Success);
        Assert.False(resultList.IsFailure);
        Assert.Equal(0.0,
            resultList.Data!);
    }
    private void UpdateValueSetup(Transaction transaction, double value)
    {
        AccountServiceMock.UpdateValueReturnResultWithAccount(transaction.TansactionDate,
            value, transaction.UserId);
        BudgetServiceMock.UpdateValueReturnResultWithBudget(transaction.TansactionDate, value, 
            transaction.UserId, transaction.CategoryId);
        
    }


}