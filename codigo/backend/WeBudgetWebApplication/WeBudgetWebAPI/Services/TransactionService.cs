using WeBudgetWebAPI.Interfaces;
using WeBudgetWebAPI.Interfaces.Sevices;
using WeBudgetWebAPI.Models;
using WeBudgetWebAPI.Models.Enums;

namespace WeBudgetWebAPI.Services;

public class TransactionService : ITransactionService
{
    private readonly ITransaction _iTransaction;
    private readonly IAccountService _accountService;
    private readonly IBudgetService _budgetService;


    public TransactionService(ITransaction iTransaction, IAccountService accountService, IBudgetService budgetService)
    {
        _iTransaction = iTransaction;
        _accountService = accountService;
        _budgetService = budgetService;
    }

    public async Task<Transaction> Add(Transaction transaction)
    {
        //TO-DO validation
        var value = 0.0;
        if (transaction.TansactionType == TansactionType.Expenses)
        {
            value = -1 * transaction.PaymentValue;
        }
        else
        {
            value = transaction.PaymentValue;
        }
        await _accountService.UpdateBalance(transaction.TansactionDate,
            value ,transaction.UserId);
        await _budgetService.UpdateUsedValue(transaction.UserId, transaction.TansactionDate,
            transaction.CategoryId, value);
        return await _iTransaction.Add(transaction);
    }

    public async Task<Transaction> Update(Transaction transaction)
    {
        var value = 0.0;
        var savedTrasacton = await _iTransaction.GetEntityById(transaction.Id);
        if (transaction.TansactionType == TansactionType.Expenses)
        {
            value = (-1 * transaction.PaymentValue)+savedTrasacton.PaymentValue;
        }
        else
        {
            value = (-1 * savedTrasacton.PaymentValue)+transaction.PaymentValue;
        }
        await _accountService.UpdateBalance(transaction.TansactionDate,
            value ,transaction.UserId);
        await _budgetService.UpdateUsedValue(transaction.UserId, transaction.TansactionDate,
            transaction.CategoryId, value);
        return await _iTransaction.Update(transaction);
    }

    public async Task Delete(Transaction transaction)
    {
        //TO-DO validation
        var value = 0.0;
        if (transaction.TansactionType == TansactionType.Expenses)
        {
            value = transaction.PaymentValue;
        }
        else
        {
            value = -1 * transaction.PaymentValue;
        }
        await _accountService.UpdateBalance(transaction.TansactionDate,
            value ,transaction.UserId);
        await _budgetService.UpdateUsedValue(transaction.UserId, transaction.TansactionDate,
            transaction.CategoryId, value);

        await _iTransaction.Delete(transaction);
    }

}