using WeBudgetWebAPI.Interfaces;
using WeBudgetWebAPI.Interfaces.Sevices;
using WeBudgetWebAPI.Models;
using WeBudgetWebAPI.Models.Enums;

namespace WeBudgetWebAPI.Services;

public class TransactionService : ITransactionService
{
    private readonly IBudget _iBudget;
    private readonly ITransaction _iTransaction;
    private readonly IAccount _iAccount;

    public TransactionService(IBudget iBudget, ITransaction iTransaction, IAccount iAccount)
    {
        _iBudget = iBudget;
        _iTransaction = iTransaction;
        _iAccount = iAccount;
    }

    public async Task<Transaction> Add(Transaction transaction)
    {
        //TO-DO validation
        var savedAccount = await _iAccount.ListByUserAndTime(transaction.UserId, transaction.TansactionDate);
        if (savedAccount == null)
        {
            savedAccount = await AccountCreator(transaction);
        }
        if (transaction.TansactionType == TansactionType.Expenses)
        {
            var budget = await _iBudget
                .ListByUserTimeAndCategory(transaction.UserId, transaction.TansactionDate, transaction.CategoryId);
            budget.BudgetValueUsed += transaction.PaymentValue;
            await _iBudget.Update(budget);
        }

        return await _iTransaction.Add(transaction);
    }

    public async Task<Transaction> Update(Transaction transaction)
    {
        //TO-DO validation
        var savedAccount = await _iAccount.ListByUserAndTime(transaction.UserId, transaction.TansactionDate);
        var savedTrasacton = await _iTransaction.GetEntityById(transaction.Id);
        if (transaction.TansactionType == TansactionType.Expenses)
        {
            var budget = await _iBudget
                .ListByUserTimeAndCategory(transaction.UserId, transaction.TansactionDate, transaction.CategoryId);
            budget.BudgetValueUsed += transaction.PaymentValue;
            budget.BudgetValueUsed -= savedTrasacton.PaymentValue;
            await _iBudget.Update(budget);
        }

        return await _iTransaction.Update(transaction);
    }

    public async Task Delete(Transaction transaction)
    {
        //TO-DO validation
        var savedAccount = await _iAccount.ListByUserAndTime(transaction.UserId, transaction.TansactionDate);
        if (transaction.TansactionType == TansactionType.Expenses)
        {
            var budget = await _iBudget
                .ListByUserTimeAndCategory(transaction.UserId, transaction.TansactionDate, transaction.CategoryId);
            budget.BudgetValueUsed -= transaction.PaymentValue;
            await _iBudget.Update(budget);
        }

        await _iTransaction.Delete(transaction);
    }

    private async Task<Account> AccountCreator(Transaction transaction)
    {
        var newAccount = await _iAccount.Add(new Account()
        {
            AccountBalance = 0.0,
            AccountDateTime = transaction.TansactionDate,
            UserId = transaction.UserId
        });
        return await _iAccount.Add(newAccount);
    }
    
}