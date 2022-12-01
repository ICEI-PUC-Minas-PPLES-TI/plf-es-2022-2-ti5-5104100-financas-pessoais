using WeBudgetWebAPI.Interfaces;
using WeBudgetWebAPI.Models;
using WeBudgetWebAPI.Models.Entities;

namespace TestWeBudgetWebAPI.Mock;

public static class AccountMock
{
    private static Mock<IAccount>? _accountMock;
    public static Mock<IAccount> GetIAccountMockInstance()
    {
        return _accountMock ??= new Mock<IAccount>();
    }
    public static void AccountMockAddReturnResultOk()
    {
        if (_accountMock != null)
            _accountMock.Setup(x => x.Add(It.IsAny<Account>()))
                .ReturnsAsync((Account x) =>
                {
                    x.Id = 0;
                    return Result.Ok(x);
                });
    }
    public static void AccountMockAddReturnResultFail()
    {
        if (_accountMock != null)
            _accountMock.Setup(x => x.Add(It.IsAny<Account>()))
                .ReturnsAsync(Result.Fail<Account>("Fail"));
    }
    public static void AccountMockUpdateReturnResultOk()
    {
        if (_accountMock != null)
            _accountMock.Setup(x => x.Update(It.IsAny<Account>()))
                .ReturnsAsync((Account x) => Result.Ok(x));
    }
    public static void AccountMockUpdateReturnResultFail()
    {
        if (_accountMock != null)
            _accountMock.Setup(x => x.Update(It.IsAny<Account>()))
                .ReturnsAsync(Result.Fail<Account>("Fail"));
    }
    public static void AccountMockDeleteReturnResultOk()
    {
        if (_accountMock != null)
            _accountMock.Setup(x => x.Delete(It.IsAny<Account>()))
                .ReturnsAsync(Result.Ok());
    }
    public static void AccountMockDeleteReturnResultFail()
    {
        if (_accountMock != null)
            _accountMock.Setup(x => x.Delete(It.IsAny<Account>()))
                .ReturnsAsync(Result.Fail("Fail"));
    }
    public static void AccountMockGetByUserAndTimeReturnResultOk(string userId, DateTime datetime)
    {
        if (_accountMock != null)
            _accountMock.Setup(x => x.GetByUserAndTime(userId, datetime))
                .ReturnsAsync(Result.Ok(ReturnAccountList(datetime).First(x =>
                    x.UserId == userId && x.AccountDateTime == datetime)));
    }
    public static void AccountMockGetByUserAndTimeReturnResultNotFound(string userId, DateTime datetime)
    {
        if (_accountMock != null)
            _accountMock.Setup(x => x.GetByUserAndTime(userId, datetime))
                .ReturnsAsync(Result.NotFound<Account>());
    }
    public static void AccountMockGetByUserAndTimeReturnResultFail(string userId, DateTime datetime)
    {
        if (_accountMock != null)
            _accountMock.Setup(x => x.GetByUserAndTime(userId, datetime))
                .ReturnsAsync(Result.Fail<Account>("Fail"));
    }
    public static void AccountMockGetByIdReturnResultOk(int id)
    {
        if (_accountMock != null)
            _accountMock.Setup(x => x.GetEntityById(id))
                .ReturnsAsync(Result.Ok(ReturnAccountList(DateTime.Now).First(x =>
                    x.Id == id)));
    }

    public static void AccountMockGetByIdReturnResultFail(int id)
    {
        if (_accountMock != null)
            _accountMock.Setup(x => x.GetEntityById(id))
                .ReturnsAsync(Result.Fail<Account>("Fail"));
    }

    public static void AccountMockGetByIdReturnResultNotFound(int id)
    {
        if (_accountMock != null)
            _accountMock.Setup(x => x.GetEntityById(id))
                .ReturnsAsync(Result.NotFound<Account>());
    }

    public static IEnumerable<Account> ReturnAccountList(DateTime datetime)
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
                AccountDateTime = datetime.AddMonths(-2)
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