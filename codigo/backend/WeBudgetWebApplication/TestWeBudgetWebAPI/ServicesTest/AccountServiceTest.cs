using TestWeBudgetWebAPI.Mock;
using WeBudgetWebAPI.Interfaces;
using WeBudgetWebAPI.Interfaces.Sevices;
using WeBudgetWebAPI.Models;
using WeBudgetWebAPI.Models.Entities;
using WeBudgetWebAPI.Services;

namespace TestWeBudgetWebAPI.ServicesTest;

public class AccountServiceTest
{
    private readonly AccountService _accountService;
    private readonly Mock<IAccount> _accountMock;

    public AccountServiceTest()
    {
        var messageMock = new Mock<IMessageBrokerService<Account>>();
        _accountMock = AccountMock.GetIAccountMockInstance();
        _accountService = new AccountService(_accountMock.Object,
            messageMock.Object);
    }
    
    [Fact]
    public async Task Add_ShouldReturnAReturnWithAnAccount()
    {
        //Arrange
        var datetime = DateTime.Now;
        var account = new Account()
        {
            UserId = "0000-0000-0000-0000",
            AccountBalance = 0.0,
            AccountDateTime = datetime
        };
        AccountMock.AccountMockAddReturnResultOk();
        //Act
        var resultAccount = await _accountService.Add(account);
        //Assert
        Assert.True(resultAccount.Success);
        Assert.False(resultAccount.IsFailure);
        Assert.False(resultAccount.NotFound);
        Assert.Equal(0, resultAccount.Data!.Id);
    }
    [Fact]
    public async Task Add_ShouldReturnAReturnWithError()
    {
        //Arrange
        var datetime = DateTime.Now;
        var account = new Account()
        {
            UserId = "0000-0000-0000-0000",
            AccountBalance = 0.0,
            AccountDateTime = datetime
        };
        AccountMock.AccountMockAddReturnResultFail();
        //Act
        var resultAccount = await _accountService.Add(account);
        //Assert
        Assert.False(resultAccount.Success);
        Assert.True(resultAccount.IsFailure);
        Assert.False(resultAccount.NotFound);
        Assert.Equal("Fail", resultAccount.ErrorMenssage);
    }
    [Fact]
    public async Task Update_ShouldReturnAReturnWithAnAccount()
    {
        //Arrange
        var datetime = DateTime.Now;
        var account = new Account()
        {
            Id=0,
            UserId = "0000-0000-0000-0000",
            AccountBalance = 5.0,
            AccountDateTime = datetime
        };
        AccountMock.AccountMockUpdateReturnResultOk();
        //Act
        var resultAccount = await _accountService.Update(account);
        //Assert
        Assert.True(resultAccount.Success);
        Assert.False(resultAccount.IsFailure);
        Assert.False(resultAccount.NotFound);
        Assert.Equal(0, resultAccount.Data!.Id);
    }
    [Fact]
    public async Task Update_ShouldReturnAReturnWithError()
    {
        //Arrange
        var datetime = DateTime.Now;
        var account = new Account()
        {
            Id=0,
            UserId = "0000-0000-0000-0000",
            AccountBalance = 0.0,
            AccountDateTime = datetime
        };
        AccountMock.AccountMockUpdateReturnResultFail();
        //Act
        var resultAccount = await _accountService.Update(account);
        //Assert
        Assert.False(resultAccount.Success);
        Assert.True(resultAccount.IsFailure);
        Assert.False(resultAccount.NotFound);
        Assert.Equal("Fail",
            resultAccount.ErrorMenssage);
    }
    [Fact]
    public async Task Delete_ShouldReturnAReturnWithSuccess()
    {
        //Arrange
        var account = new Account();
        AccountMock.AccountMockDeleteReturnResultOk();
        //Act
        var deleteResult = await _accountService.Delete(account);
        //Assert
        Assert.True(deleteResult.Success);
        Assert.False(deleteResult.IsFailure);
    }
    [Fact]
    public async Task Delete_ShouldReturnAReturnWithErrorMessage()
    {
        //Arrange
        var account = new Account();
        AccountMock.AccountMockDeleteReturnResultFail();
        //Act
        var deleteResult = await _accountService.Delete(account);
        //Assert
        Assert.False(deleteResult.Success);
        Assert.True(deleteResult.IsFailure);
        Assert.Equal("Fail",
            deleteResult.ErrorMenssage);
    }
    [Fact]
    public async Task List_ShouldReturnAReturnWithAccountList()
    {
        //Arrange
        var datetime = DateTime.Now;
        _accountMock.Setup(x => x.List())
            .ReturnsAsync(Result.Ok(AccountMock.ReturnAccountList(datetime)
                .ToList()));
        //Act
        var resultList = await _accountService.List();
        //Assert
        Assert.True(resultList.Success);
        Assert.False(resultList.IsFailure);
        Assert.Equal(4, resultList.Data!.Count);
    }
    [Fact]
    public async Task List_ShouldReturnAReturnWithErrorMessage()
    {
        //Arrange
        _accountMock.Setup(x => x.List())
            .ReturnsAsync(Result.Fail<List<Account>>("Fail"));
        //Act
        var resultList = await _accountService.List();
        //Assert
        Assert.False(resultList.Success);
        Assert.True(resultList.IsFailure);
        Assert.Equal("Fail",
            resultList.ErrorMenssage);
    }
    [Fact]
    public async Task ListByUser_ShouldReturnAReturnWithAccountList()
    {
        //Arrange
        var datetime = DateTime.Now;
        var userId = "0000-0000-0000-0000";
        _accountMock.Setup(x => x.ListByUser(userId))
            .ReturnsAsync(Result.Ok(AccountMock.ReturnAccountList(datetime)
                .Where(x=>x.UserId==userId).ToList()));
        //Act
        var resultList = await _accountService.ListByUser(userId);
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
        _accountMock.Setup(x => x.ListByUser(userId))
            .ReturnsAsync(Result.Fail<List<Account>>("Fail"));
        //Act
        var resultList = await _accountService.ListByUser(userId);
        //Assert
        Assert.False(resultList.Success);
        Assert.True(resultList.IsFailure);
        Assert.Equal("Fail",
            resultList.ErrorMenssage);
    }
    [Fact]
    public async Task GetByUserAndTime_ShouldReturnAReturnWithAccount()
    {
        //Arrange
        var datetime = DateTime.Now;
        var userId = "0000-0000-0000-0000";
        AccountMock.AccountMockGetByUserAndTimeReturnResultOk(userId,datetime);
        //Act
        var resultAccount = await _accountService.GetByUserAndTime(userId, datetime);
        //Assert
        Assert.True(resultAccount.Success);
        Assert.False(resultAccount.IsFailure);
        Assert.Equal(userId, resultAccount.Data!.UserId);
        Assert.Equal(datetime.Month,
            resultAccount.Data!.AccountDateTime.Month );
        Assert.Equal(datetime.Year,
            resultAccount.Data!.AccountDateTime.Year );
    }
    [Fact]
    public async Task GetByUserAndTime_ShouldReturnAReturnWithErrorMessage()
    {
        //Arrange
        var datetime = DateTime.Now;
        var userId = "0000-0000-0000-0000";
        AccountMock.AccountMockGetByUserAndTimeReturnResultFail(userId,datetime);
        //Act
        var resultAccount = await _accountService.GetByUserAndTime(userId, datetime);
        //Assert
        Assert.False(resultAccount.Success);
        Assert.True(resultAccount.IsFailure);
        Assert.Equal("Fail",
            resultAccount.ErrorMenssage);
    }
    [Fact]
    public async Task GetByUserAndTime_ShouldReturnAReturnWithNotFound()
    {
        //Arrange
        var datetime = DateTime.Now;
        var userId = "0000-0000-0000-0000";
        AccountMock.AccountMockGetByUserAndTimeReturnResultNotFound(userId, datetime);
        //Act
        var resultAccount = await _accountService.GetByUserAndTime(userId, datetime);
        //Assert
        Assert.True(resultAccount.Success);
        Assert.False(resultAccount.IsFailure);
        Assert.True(resultAccount.NotFound);
    }
    [Fact]
    public async Task GetById_ShouldReturnAReturnWithAccount()
    {
        //Arrange
        var id = 0;
        AccountMock.AccountMockGetByIdReturnResultOk(id);
        //Act
        var resultAccount = await _accountService.GetEntityById(id);
        //Assert
        Assert.True(resultAccount.Success);
        Assert.False(resultAccount.IsFailure);
        Assert.Equal(id, resultAccount.Data!.Id);
    }
    [Fact]
    public async Task GetById_ShouldReturnAReturnWithErrorMessage()
    {
        //Arrange
        var id = 0;
        AccountMock.AccountMockGetByIdReturnResultFail(id);
        //Act
        var resultAccount = await _accountService.GetEntityById(id);
        //Assert
        Assert.False(resultAccount.Success);
        Assert.True(resultAccount.IsFailure);
        Assert.Equal("Fail",
            resultAccount.ErrorMenssage);
    }
    [Fact]
    public async Task GetById_ShouldReturnAReturnWithNotFound()
    {
        //Arrange
        var id = 0;
        AccountMock.AccountMockGetByIdReturnResultNotFound(id);
        //Act
        var resultAccount = await _accountService.GetEntityById(id);
        //Assert
        Assert.True(resultAccount.Success);
        Assert.False(resultAccount.IsFailure);
        Assert.True(resultAccount.NotFound);
    }
    [Fact]
    public async Task Create_ShouldReturnAReturnWithAnAccount()
    {
        //Arrange
        var datetime = DateTime.Now;
        var userId = "0000-0000-0000-0000";
        AccountMock.AccountMockAddReturnResultOk();
        //Act
        var resultAccount = await _accountService.Create(userId, datetime);
        //Assert
        Assert.True(resultAccount.Success);
        Assert.False(resultAccount.IsFailure);
        Assert.False(resultAccount.NotFound);
        Assert.Equal(userId, resultAccount.Data!.UserId);
        Assert.Equal(datetime.Month,
            resultAccount.Data!.AccountDateTime.Month );
        Assert.Equal(datetime.Year,
            resultAccount.Data!.AccountDateTime.Year );
    }
    [Fact]
    public async Task Create_ShouldReturnAReturnWithError()
    {
        //Arrange
        var datetime = DateTime.Now;
        var userId = "0000-0000-0000-0000";
        AccountMock.AccountMockAddReturnResultFail();
        //Act
        var resultAccount = await _accountService.Create(userId, datetime);
        //Assert
        Assert.False(resultAccount.Success);
        Assert.True(resultAccount.IsFailure);
        Assert.False(resultAccount.NotFound);
        Assert.Equal("Fail", resultAccount.ErrorMenssage);
    }
    [Fact]
    public async Task UpdateBalance_ShouldReturnAReturnWithAnAccount()
    {
        //Arrange
        var datetime = DateTime.Now;
        var userId = "0000-0000-0000-0000";
        AccountMock.AccountMockGetByUserAndTimeReturnResultNotFound(userId,datetime);
        AccountMock.AccountMockAddReturnResultOk();
        AccountMock.AccountMockUpdateReturnResultOk();
        //Act
        var resultAccount = await _accountService.UpdateBalance(datetime, 100.0, userId);
        //Assert
        Assert.True(resultAccount.Success);
        Assert.False(resultAccount.IsFailure);
        Assert.False(resultAccount.NotFound);
        Assert.Equal(userId, resultAccount.Data!.UserId);
        Assert.Equal(datetime.Month,
            resultAccount.Data!.AccountDateTime.Month );
        Assert.Equal(datetime.Year,
            resultAccount.Data!.AccountDateTime.Year );
        Assert.Equal(100.0, resultAccount.Data!.AccountBalance);
    }
    [Fact]
    public async Task UpdateBalance_ShouldReturnAReturnWithError()
    {
        //Arrange
        var datetime = DateTime.Now;
        var userId = "0000-0000-0000-0000";
        AccountMock.AccountMockGetByUserAndTimeReturnResultNotFound(userId,datetime);
        AccountMock.AccountMockAddReturnResultOk();
        AccountMock.AccountMockUpdateReturnResultFail();
        //Act
        var resultAccount = await _accountService.UpdateBalance(datetime, 100.0, userId);
        //Assert
        Assert.False(resultAccount.Success);
        Assert.True(resultAccount.IsFailure);
        Assert.False(resultAccount.NotFound);
        Assert.Equal("Fail", resultAccount.ErrorMenssage);
    }

}