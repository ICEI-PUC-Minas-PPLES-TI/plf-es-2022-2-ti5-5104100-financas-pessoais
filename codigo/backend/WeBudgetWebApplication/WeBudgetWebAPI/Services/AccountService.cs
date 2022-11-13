using WeBudgetWebAPI.Interfaces;
using WeBudgetWebAPI.Interfaces.Sevices;
using WeBudgetWebAPI.Models;

namespace WeBudgetWebAPI.Services;

public class AccountService:IAccountService
{

    public readonly IAccount _iAccount;

    public AccountService(IAccount iAccount)
    {
        _iAccount = iAccount;
    }

    public async Task<Account> Add(Account account)
    {
        return await _iAccount.Add(account);
    }

    public async Task<Account> Update(Account account)
    {
        return await _iAccount.Update(account);
    }

    public async Task Delete(Account account)
    {
        await _iAccount.Delete(account);
    }

    public async Task<Account> GetEntityById(int id)
    {
       return await _iAccount.GetEntityById(id);
    }

    public async Task<List<Account>> List()
    {
        return await _iAccount.List();
    }

    public async Task<List<Account>> ListByUser(string userId)
    {
        return await _iAccount.ListByUser(userId);
    }

    public async Task<Account> ListByUserAndTime(string userId, DateTime dateTime)
    {
        return await _iAccount.ListByUserAndTime(userId, dateTime);
    }

    public async Task<Account> Create(string userId, DateTime dateTime)
    {
        var newAccount = await _iAccount.Add(new Account()
        {
            AccountBalance = 0.0,
            AccountDateTime = dateTime,
            UserId = userId
        });
        return await _iAccount.Add(newAccount);
    }

    public async Task<Account> UpdateBalance(DateTime dateTime, double value, string userId)
    {
        throw new NotImplementedException();
    }
}