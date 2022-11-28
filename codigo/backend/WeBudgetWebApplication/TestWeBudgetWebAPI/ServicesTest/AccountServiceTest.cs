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
        var result = Result<Account>.Ok(new Account()
        {
            Id=0,
            UserId = "0000-0000-0000-0000",
            AccountBalance = 0.0,
            AccountDateTime = datetime
        });
        _accountMock.Setup(x => x.Add(account))
            .ReturnsAsync(result);
        //Act
        var resultAccout = await _accountService.Add(account);
        //Assert
        Assert.True(resultAccout.Success);
        Assert.False(resultAccout.IsFailure);
        Assert.False(resultAccout.NotFound);
        Assert.Equal(0, resultAccout.Data!.Id);
    }
}