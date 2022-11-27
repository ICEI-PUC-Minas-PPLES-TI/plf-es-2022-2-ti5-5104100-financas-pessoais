using WeBudgetWebAPI.Models;
using WeBudgetWebAPI.Models.Entities;

namespace WeBudgetWebAPI.Interfaces.Sevices;

public interface IAccountService:IAccount
{
    Task<Result<Account>> Create(string userId, DateTime dateTime);
    Task<Result<Account>> UpdateBalance(DateTime dateTime, double value, string userId);
}