using WeBudgetWebAPI.Interfaces;
using WeBudgetWebAPI.Interfaces.Sevices;
using WeBudgetWebAPI.Models;
using WeBudgetWebAPI.Models.Entities;
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

    public async Task<Result<Account>> Add(Account account)
    {
        var result = await _iAccount.Add(account);
        if (result.Success) 
            await SendMessage(OperationType.Create,result.Data!);
        return result;
    }

    public async Task<Result<Account>> Update(Account account)
    {
        var result = await _iAccount.Update(account);
        if (result.Success)
            await SendMessage(OperationType.Update,result.Data!);
        return result;
    }

    public async Task<Result> Delete(Account account)
    {
        var result = await _iAccount.Delete(account);
        if (result.Success) 
            await SendMessage(OperationType.Delete, account);
        return result;
    }

    public async Task<Result<Account>> GetEntityById(int id)
    {
        return await _iAccount.GetEntityById(id);
    }

    public async Task<Result<List<Account>>> List()
    {
        return await _iAccount.List();
    }

    public async Task<Result<List<Account>>> ListByUser(string userId)
    {
        return await _iAccount.ListByUser(userId);
    }

    public async Task<Result<Account>> GetByUserAndTime(string userId, DateTime dateTime)
    {
        return await _iAccount.GetByUserAndTime(userId, dateTime);
    }
 
    public async Task<Result<Account>> Create(string userId, DateTime dateTime)
    {
        var result = await _iAccount.Add(new Account()
        {
            AccountBalance = 0.0,
            AccountDateTime = dateTime,
            UserId = userId
        });
        if (result.Success)
            await SendMessage(OperationType.Create, result.Data!);
        return result;
    }

    public async Task<Result<Account>> UpdateBalance(DateTime dateTime, double value, string userId)
    {
        var savedAccountResult = await _iAccount
            .GetByUserAndTime(userId, dateTime);
        if (savedAccountResult.IsFailure)
            return savedAccountResult;
        savedAccountResult=savedAccountResult.NotFound?
            await Create(userId, dateTime):savedAccountResult;
        savedAccountResult.Data!.AccountBalance += value;
        var updatedAccountResult = await _iAccount.Update(savedAccountResult.Data);
        if(updatedAccountResult.Success) 
            await SendMessage(OperationType.Update,updatedAccountResult.Data!);
        return updatedAccountResult;
    }
    
    private  Task SendMessage(OperationType operation, Account account)
    {
        _messageBrokerService.SendMessage(TableType.Account, operation, account.UserId,account);
        return Task.CompletedTask;
    }
}