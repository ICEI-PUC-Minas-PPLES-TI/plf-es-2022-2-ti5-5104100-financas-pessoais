using WeBudgetWebAPI.Interfaces.Generics;
using WeBudgetWebAPI.Models;

namespace WeBudgetWebAPI.Interfaces;

public interface ITransaction:IGeneric<Transaction>
{
    public Task<List<Transaction>> ListByUser(string userId);
}