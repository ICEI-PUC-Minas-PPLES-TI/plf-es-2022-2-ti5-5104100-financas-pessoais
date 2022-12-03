using WeBudgetWebAPI.Interfaces.Sevices;
using WeBudgetWebAPI.Models;
using WeBudgetWebAPI.Models.Entities;

namespace TestWeBudgetWebAPI.Mock;

public static class AccountServiceMock
{
    private static Mock<IAccountService>? _accountServiceMock;
    public static Mock<IAccountService> GetIAccountServiceMockInstance()
    {
        return _accountServiceMock ??= new Mock<IAccountService>();
    }

    public static void UpdateValueReturnResultWithAccount(DateTime dateTime, double value,
        string userId)
    {
        var account = new Account()
        {
            Id = 0,
            UserId = userId,
            AccountBalance = (1000.00 + value),
            AccountDateTime = dateTime
        };
        if(_accountServiceMock!=null) 
            _accountServiceMock.Setup(x => x.UpdateBalance(dateTime, value, userId))
            .ReturnsAsync(Result.Ok(account));
    }
}