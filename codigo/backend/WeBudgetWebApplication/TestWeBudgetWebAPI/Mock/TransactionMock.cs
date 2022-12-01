using WeBudgetWebAPI.Interfaces;
using WeBudgetWebAPI.Models;
using WeBudgetWebAPI.Models.Entities;

namespace TestWeBudgetWebAPI.Mock;

public static class TransactionMock
{
    private static Mock<ITransaction>? _transactionMock;
    public static Mock<ITransaction> GetITransactionMockInstance()
    {
        return _transactionMock ??= new Mock<ITransaction>();
    }

    public static void TransactionMockReturnResultSum(string userId, DateTime dateTime, int categoryId)
    {
        if (_transactionMock != null)
            _transactionMock.Setup(x => x.SumTransaction(userId, dateTime, categoryId))
                .ReturnsAsync(Result.Ok(0.0));
 
    }
    public static void TransactionMockAddReturnResultOk()
    {
        if (_transactionMock != null)
            _transactionMock.Setup(x => x.Add(It.IsAny<Transaction>()))
                .ReturnsAsync((Transaction x) =>
                {
                    x.Id = 0;
                    return Result.Ok(x);
                });
    }
}