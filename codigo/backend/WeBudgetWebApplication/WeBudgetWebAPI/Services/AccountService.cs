using WeBudgetWebAPI.DTOs;
using WeBudgetWebAPI.Interfaces;
using WeBudgetWebAPI.Interfaces.Sevices;
using WeBudgetWebAPI.Models;
using WeBudgetWebAPI.Models.Enums;

namespace WeBudgetWebAPI.Services;

public class AccountService:IAccountService
{

    private readonly IAccount _iAccount;
    private readonly IMessageBrokerService<Account> _messageBrokerService;

    public AccountService(IAccount iAccount, IMessageBrokerService<Account> messageBrokerService)
    {
        _iAccount = iAccount;
        _messageBrokerService = messageBrokerService;
    }

    public async Task<Account> Add(Account account)
    {
        return await SendMenssage(OperationType.Create,
            await _iAccount.Add(account));
    }

    public async Task<Account> Update(Account account)
    {
        return await SendMenssage(OperationType.Update,
            await _iAccount.Update(account));
    }

    public async Task Delete(Account account)
    {
        await _iAccount.Delete(account);
        await SendMenssage(OperationType.Delete,account);
    }

    public async Task<Account?> GetEntityById(int id)
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

    public async Task<Account?> GetByUserAndTime(string userId, DateTime dateTime)
    {
        return await _iAccount.GetByUserAndTime(userId, dateTime);
    }
 
    public async Task<Account> Create(string userId, DateTime dateTime)
    {
        var newAccount = await _iAccount.Add(new Account()
        {
            AccountBalance = 0.0,
            AccountDateTime = dateTime,
            UserId = userId
        });
        return await SendMenssage(OperationType.Create,
            await _iAccount.Add(newAccount));
    }

    public async Task<Account> UpdateBalance(DateTime dateTime, double value, string userId)
    {
        var savedAccount = await _iAccount
            .GetByUserAndTime(userId, dateTime);
        
        if (savedAccount == null)
        {
            savedAccount = await Create(userId, dateTime);
        }
        
        return await SendMenssage(OperationType.Update,
            savedAccount);
    }
    
    private async Task<Account> SendMenssage(OperationType operation, Account account)
    {
        return await _messageBrokerService.SendMenssage(new MenssageResponse<Account>()
        {
            Table = TableType.Account,
            UserId = account.UserId,
            Operation = operation,
            Object = account
        });
    }
}