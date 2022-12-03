using WeBudgetWebAPI.Interfaces;
using WeBudgetWebAPI.Models;
using WeBudgetWebAPI.Models.Entities;
using WeBudgetWebAPI.Models.Enums;

namespace TestWeBudgetWebAPI.Mock;

public static class TransactionMock
{
    private static Mock<ITransaction>? _transactionMock;
    public static Mock<ITransaction> GetITransactionMockInstance()
    {
        return _transactionMock ??= new Mock<ITransaction>();
    }

    public static void ReturnResultSum(string userId, DateTime dateTime, int categoryId)
    {
        if (_transactionMock != null)
            _transactionMock.Setup(x => x.SumTransaction(userId, dateTime, categoryId))
                .ReturnsAsync(Result.Ok(0.0));
 
    }
    public static void AddReturnResultOk()
    {
        if (_transactionMock != null)
            _transactionMock.Setup(x => x.Add(It.IsAny<Transaction>()))
                .ReturnsAsync((Transaction x) =>
                {
                    x.Id = 0;
                    return Result.Ok(x);
                });
    }
    public static void AddReturnResultFail()
    {
        if (_transactionMock != null)
            _transactionMock.Setup(x => x.Add(It.IsAny<Transaction>()))
                .ReturnsAsync(Result.Fail<Transaction>("Fail"));
    }

    public static void UpdateReturnResultOk()
    {
        if (_transactionMock != null)
            _transactionMock.Setup(x => x.Update(It.IsAny<Transaction>()))
                .ReturnsAsync((Transaction x) => Result.Ok(x));
    }

    public static void UpdateReturnResultFail()
    {
        if (_transactionMock != null)
            _transactionMock.Setup(x => x.Update(It.IsAny<Transaction>()))
                .ReturnsAsync(Result.Fail<Transaction>("Fail"));
    }

    public static void GetEntityByIdReturnResultOk(int transactionId)
    {
        if (_transactionMock != null)
            _transactionMock.Setup(x => x.GetEntityById(transactionId))
                .ReturnsAsync(Result.Ok(ReturnTransactionCollection(DateTime.Now).First(x =>
                    x.Id == transactionId)));
    }
    public static void GetEntityByIdReturnResultFail(int transactionId)
    {
        if (_transactionMock != null)
            _transactionMock.Setup(x => x.GetEntityById(transactionId))
                .ReturnsAsync(Result.Fail<Transaction>("Fail"));
    }
    public static void GetEntityByIdReturnResultNotFound(int transactionId)
    {
        if (_transactionMock != null)
            _transactionMock.Setup(x => x.GetEntityById(transactionId))
                .ReturnsAsync(Result.NotFound<Transaction>());
    }
    public static void DeleteReturnResultOk()
    {
        if (_transactionMock != null)
            _transactionMock.Setup(x => x.Delete(It.IsAny<Transaction>()))
                .ReturnsAsync(Result.Ok());
    }
    public static void DeleteReturnResultError()
    {
        if (_transactionMock != null)
            _transactionMock.Setup(x => x.Delete(It.IsAny<Transaction>()))
                .ReturnsAsync(Result.Fail("Fail"));
    }
    public static void ListReturnResultFail()
    {
        if (_transactionMock != null)
            _transactionMock.Setup(x => x.List())
                .ReturnsAsync(Result.Fail<List<Transaction>>("Fail"));
    }

    public static void ListReturnResultOk()
    {
        if (_transactionMock != null)
            _transactionMock.Setup(x => x.List())
                .ReturnsAsync(Result.Ok(ReturnTransactionCollection(DateTime.Now).ToList()));
    }
    private static IEnumerable<Transaction> ReturnTransactionCollection(DateTime dateTime)
    {
        return new List<Transaction>()
        {
            new Transaction()
            {
                Id = 0,
                UserId = "0000-0000-0000-0000",
                Address = "5th avenue",
                Latitude = 0.0,
                Longitude = 0.0,
                Description = "Tax",
                CategoryId = 0,
                TansactionDate = dateTime,
                PaymentValue = 100.00,
                TansactionType = TansactionType.Expenses,
                PaymentType = "credit"
                
            },
            new Transaction()
            {
                Id = 1,
                UserId = "0000-0000-0000-0000",
                Address = "5th avenue",
                Latitude = 0.0,
                Longitude = 0.0,
                Description = "Car",
                CategoryId = 0,
                TansactionDate = dateTime,
                PaymentValue = 100.00,
                TansactionType = TansactionType.Expenses,
                PaymentType = "credit"
                
            },
            new Transaction()
            {
                Id = 2,
                UserId = "0000-0000-0000-0000",
                Address = "5th avenue",
                Latitude = 0.0,
                Longitude = 0.0,
                Description = "Tax",
                CategoryId = 0,
                TansactionDate = dateTime,
                PaymentValue = 100.00,
                TansactionType = TansactionType.Expenses,
                PaymentType = "credit"
                
            },
            new Transaction()
            {
                Id = 3,
                UserId = "0000-0000-0000-0001",
                Address = "5th avenue",
                Latitude = 0.0,
                Longitude = 0.0,
                Description = "Tax",
                CategoryId = 0,
                TansactionDate = dateTime,
                PaymentValue = 100.00,
                TansactionType = TansactionType.Expenses,
                PaymentType = "credit"
                
            },
        };
    }


    public static void ListByUserReturnResultOk(string userId)
    {
        if (_transactionMock != null)
            _transactionMock.Setup(x => x.ListByUser(userId))
                .ReturnsAsync(Result.Ok(ReturnTransactionCollection(DateTime.Now)
                    .Where(x=>x.UserId==userId).ToList()));
    }

    public static void ListByUserReturnResultFail(string userId)
    {
        if (_transactionMock != null)
            _transactionMock.Setup(x => x.ListByUser(userId))
                .ReturnsAsync(Result.Fail<List<Transaction>>("Fail"));
    }
}