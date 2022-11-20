using WeBudgetWebAPI.Models;
using WeBudgetWebAPI.Models.Entities;

namespace WeBudgetWebAPI.Interfaces.Sevices;

public interface IAccountService:IAccount
{
    Task<Account> Create(string userId, DateTime dateTime);
    Task<Account> UpdateBalance(DateTime dateTime, double value, string userId);
}