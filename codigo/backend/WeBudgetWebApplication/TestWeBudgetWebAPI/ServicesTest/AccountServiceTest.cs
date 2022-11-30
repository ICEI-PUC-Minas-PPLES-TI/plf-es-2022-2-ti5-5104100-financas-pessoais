using Microsoft.AspNetCore.Authorization;
using WeBudgetWebAPI.Interfaces;
using WeBudgetWebAPI.Interfaces.Sevices;
using WeBudgetWebAPI.Models;
using WeBudgetWebAPI.Models.Entities;
using WeBudgetWebAPI.Services;

namespace TestWeBudgetWebAPI.ServicesTest;

public class AccountServiceTest
{
    private readonly AccountService _accountService;
    private readonly Mock<IAccount> _accountMock 
        = new Mock<IAccount>();
    private readonly Mock<IMessageBrokerService<Account>> _messageMock
        = new Mock<IMessageBrokerService<Account>>();

    public AccountServiceTest()
    {
        _accountService = new AccountService(_accountMock.Object,
            _messageMock.Object);
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
        AccountMockAddReturnResultOk();
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
        AccountMockAddReturnResultFail();
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
        AccountMockUpdateReturnResultOk();
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
        AccountMockUpdateReturnResultFail();
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
        var datetime = DateTime.Now;
        var account = new Account()
        {
            Id=0,
            UserId = "0000-0000-0000-0000",
            AccountBalance = 5.0,
            AccountDateTime = datetime
        };
        AccountMockDeleteReturnResultOk();
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
        var datetime = DateTime.Now;
        var account = new Account()
        {
            Id=0,
            UserId = "0000-0000-0000-0000",
            AccountBalance = 5.0,
            AccountDateTime = datetime
        };
        AccountMockDeleteReturnResultFail();
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
            .ReturnsAsync(Result.Ok<List<Account>>(ReturnAccountList(datetime)));
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
        var result = Result.Fail<List<Account>>("Fail");
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
            .ReturnsAsync(Result.Ok(ReturnAccountList(datetime)
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
    public async Task GetByUserAndTime_ShouldReturnAReturnWithAccountList()
    {
        //Arrange
        var datetime = DateTime.Now;
        var userId = "0000-0000-0000-0000";
        
        _accountMock.Setup(x => x.GetByUserAndTime(userId, datetime))
            .ReturnsAsync(Result.Ok<Account>(ReturnAccountList(datetime).First(x => x.UserId==userId
                && x.AccountDateTime == datetime)));
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
        _accountMock.Setup(x => x.GetByUserAndTime(userId, datetime))
            .ReturnsAsync(Result.Fail<Account>("Fail"));
        //Act
        var resultAccount = await _accountService.GetByUserAndTime(userId, datetime);
        //Assert
        Assert.False(resultAccount.Success);
        Assert.True(resultAccount.IsFailure);
        Assert.Equal("A problem happen",
            resultAccount.ErrorMenssage);
    }
    [Fact]
    public async Task GetByUserAndTime_ShouldReturnAReturnWithNotFound()
    {
        //Arrange
        var datetime = DateTime.Now;
        var userId = "0000-0000-0000-0000";
        _accountMock.Setup(x => x.GetByUserAndTime(userId, datetime))
            .ReturnsAsync(Result.NotFound<Account>());
        //Act
        var resultAccount = await _accountService.GetByUserAndTime(userId, datetime);
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
        AccountMockAddReturnResultOk();
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
        AccountMockAddReturnResultFail();
        //Act
        var resultAccount = await _accountService.Create(userId, datetime);
        //Assert
        Assert.False(resultAccount.Success);
        Assert.True(resultAccount.IsFailure);
        Assert.False(resultAccount.NotFound);
        Assert.Equal("Fail", resultAccount.ErrorMenssage);
    }
    [Fact(Skip = "WIP")]
    public async Task UpdateBalance_ShouldReturnAReturnWithAnAccount()
    {
        //Arrange
        var datetime = DateTime.Now;
        var userId = "0000-0000-0000-0000";
        
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
    [Fact(Skip = "WIP")]
    public async Task UpdateBalance_ShouldReturnAReturnWithError()
    {
        //Arrange
        var datetime = DateTime.Now;
        var userId = "0000-0000-0000-0000";
        var result = Result.Fail<Account>("Cannot save the entity");
        _accountMock.Setup(x => x.Add(It.IsAny<Account>()))
            .ReturnsAsync(result);
        //Act
        var resultAccount = await _accountService.Create(userId, datetime);
        //Assert
        Assert.False(resultAccount.Success);
        Assert.True(resultAccount.IsFailure);
        Assert.False(resultAccount.NotFound);
        Assert.Equal("Cannot save the entity", resultAccount.ErrorMenssage);
    }

    private void AccountMockAddReturnResultOk()
    {
        _accountMock.Setup(x => x.Add(It.IsAny<Account>()))
            .ReturnsAsync((Account a) =>
            {
                a.Id = 0;
                return Result.Ok(a);
            });
    }
    private void AccountMockAddReturnResultFail()
    {
        _accountMock.Setup(x => x.Add(It.IsAny<Account>()))
            .ReturnsAsync(Result.Fail<Account>("Fail"));
    }
    private void AccountMockUpdateReturnResultOk()
    {
        _accountMock.Setup(x => x.Update(It.IsAny<Account>()))
            .ReturnsAsync((Account a) => Result.Ok(a));
    }
    private void AccountMockUpdateReturnResultFail()
    {
        _accountMock.Setup(x => x.Update(It.IsAny<Account>()))
            .ReturnsAsync(Result.Fail<Account>("Fail"));
    }
    private void AccountMockDeleteReturnResultOk()
    {
        _accountMock.Setup(x => x.Delete(It.IsAny<Account>()))
            .ReturnsAsync(Result.Ok());
    }
    private void AccountMockDeleteReturnResultFail()
    {
        _accountMock.Setup(x => x.Delete(It.IsAny<Account>()))
            .ReturnsAsync(Result.Fail("Fail"));
    }

    private List<Account> ReturnAccountList(DateTime datetime)
    {

        return new List<Account>()
        {
            new Account()
            {
                Id = 0,
                UserId = "0000-0000-0000-0000",
                AccountBalance = 5.0,
                AccountDateTime = datetime
            },
            new Account()
            {
                Id = 1,
                UserId = "0000-0000-0000-0000",
                AccountBalance = 5.0,
                AccountDateTime = datetime
            },
            new Account()
            {
                Id = 2,
                UserId = "0000-0000-0000-0000",
                AccountBalance = 4.0,
                AccountDateTime = datetime.AddMonths(-1)
            },
            new Account()
            {
                Id = 3,
                UserId = "0000-0000-0000-0001",
                AccountBalance = 4.0,
                AccountDateTime = datetime
            }
        };
    }

}