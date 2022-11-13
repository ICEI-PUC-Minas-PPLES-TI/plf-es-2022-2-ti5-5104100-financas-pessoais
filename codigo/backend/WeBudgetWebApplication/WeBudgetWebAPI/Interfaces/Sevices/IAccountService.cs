using WeBudgetWebAPI.Interfaces.Generics;
using WeBudgetWebAPI.Models;

namespace WeBudgetWebAPI.Interfaces.Sevices;

public interface IAccountService:IGeneric<Account>
{
    public Task<List<Account>> ListByUser(string userId);
    public Task<Account> ListByUserAndTime(string userId, DateTime dateTime);
    Task<Account> Create(string userId, DateTime dateTime);
    Task<Account> UpdateBalance(DateTime dateTime, double value, string userId);
}