using WeBudgetWebAPI.Interfaces.Generics;
using WeBudgetWebAPI.Models;
using WeBudgetWebAPI.Models.Entities;

namespace WeBudgetWebAPI.Interfaces;

public interface ITransaction:IGeneric<Transaction>
{
    public Task<Result<List<Transaction>>> ListByUser(string userId);
    public Task<Result<Double>> SumTransaction(string userId, DateTime dateTime);
}