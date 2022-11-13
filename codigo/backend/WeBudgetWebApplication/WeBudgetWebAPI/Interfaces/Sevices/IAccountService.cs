using WeBudgetWebAPI.Models;

namespace WeBudgetWebAPI.Interfaces.Sevices;

public interface IAccountService:IAccount
{
    Task<Account> Create(string userId, DateTime dateTime);
    Task<Account> UpdateBalance(DateTime dateTime, double value, string userId);
}