using WeBudgetWebAPI.Interfaces.Generics;
using WeBudgetWebAPI.Models;

namespace WeBudgetWebAPI.Interfaces;

public interface IAccount:IGeneric<Account>
{
    public Task<List<Account>> ListByUser(string userId);
    public Task<Account?> GetByUserAndTime(string userId, DateTime dateTime);
}