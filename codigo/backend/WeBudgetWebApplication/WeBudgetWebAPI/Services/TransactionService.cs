using WeBudgetWebAPI.DTOs;
using WeBudgetWebAPI.DTOs.Response;
using WeBudgetWebAPI.Interfaces;
using WeBudgetWebAPI.Interfaces.Sevices;
using WeBudgetWebAPI.Models;
using WeBudgetWebAPI.Models.Entities;
using WeBudgetWebAPI.Models.Enums;

namespace WeBudgetWebAPI.Services;

public class TransactionService : ITransactionService
{
    private readonly ITransaction _iTransaction;
    private readonly IAccountService _accountService;
    private readonly IBudgetService _budgetService;
    private readonly IMessageBrokerService<Transaction> _messageBrokerService;

    public TransactionService(ITransaction iTransaction, IAccountService accountService,
        IBudgetService budgetService, IMessageBrokerService<Transaction> messageBrokerService)
    {
        _iTransaction = iTransaction;
        _accountService = accountService;
        _budgetService = budgetService;
        _messageBrokerService = messageBrokerService;
    }

    public async Task<Result<Transaction>> Add(Transaction transaction)
    {
        
        var addedTransactionResult = await _iTransaction.Add(transaction);
        if (addedTransactionResult.IsFailure)
            return addedTransactionResult;
        await SendMessage(OperationType.Create,addedTransactionResult.Data!);
        var value = transaction.TansactionType == TansactionType.Expenses?
                -transaction.PaymentValue:transaction.PaymentValue;
        var updateValuesResult = await UpdateValues(transaction, value);
        return updateValuesResult.IsFailure ? 
            Result.Fail<Transaction>(updateValuesResult.ErrorMenssage!) : addedTransactionResult;
    }

    public async Task<Result<Transaction>> Update(Transaction transaction)
    {
        var savedTransactionResult = await _iTransaction.GetEntityById(transaction.Id);
        if (savedTransactionResult.IsFailure || savedTransactionResult.NotFound)
            return savedTransactionResult;
        var updatedTransactionResult = await _iTransaction.Update(transaction);
        if (updatedTransactionResult.IsFailure)
            return updatedTransactionResult;
        await SendMessage(OperationType.Update,updatedTransactionResult.Data!);
        var value = transaction.TansactionType == TansactionType.Expenses
            ? (savedTransactionResult.Data!.PaymentValue - transaction.PaymentValue)
            : (savedTransactionResult.Data!.PaymentValue + transaction.PaymentValue);
        var updateValuesResult = await UpdateValues(transaction, value);
        return updateValuesResult.IsFailure ? 
            Result.Fail<Transaction>(updateValuesResult.ErrorMenssage!) : updatedTransactionResult;
    }

    public async Task<Result> Delete(Transaction transaction)
    {
        var deletedTransactionResult = await _iTransaction.Delete(transaction);
        if(deletedTransactionResult.IsFailure)
            return deletedTransactionResult;
        await SendMessage(OperationType.Delete, transaction);
        var value = transaction.TansactionType == TansactionType.Expenses?
            transaction.PaymentValue:-transaction.PaymentValue;
        var updateValuesResult = await UpdateValues(transaction, value);
        return updateValuesResult.IsFailure ? 
            Result.Fail<Transaction>(updateValuesResult.ErrorMenssage!) : deletedTransactionResult;
    }

    public async Task<Result<Transaction>> GetEntityById(int id)
    {
        return await _iTransaction.GetEntityById(id);
    }

    public async Task<Result<List<Transaction>>> List()
    {
        return await _iTransaction.List();
    }

    public async Task<Result<List<Transaction>>> ListByUser(string userId)
    {
        return await _iTransaction.ListByUser(userId);
    }

    public  async Task<Result<double>> SumTransaction(string userId, DateTime dateTime, int categoryId)
    {
        return await _iTransaction.SumTransaction(userId, dateTime, categoryId);
    }

    private Task SendMessage(OperationType operation, Transaction transaction)
    {
        _messageBrokerService.SendMessage(TableType.Transaction, operation,
            transaction.UserId, transaction);
        return Task.CompletedTask;
    }

    private async Task<Result> UpdateValues(Transaction transaction, double value)
    {
        var updateBalanceResult = await _accountService.UpdateBalance(transaction.TansactionDate,
            value ,transaction.UserId);
        if(updateBalanceResult.IsFailure)
            return Result.Fail(updateBalanceResult.ErrorMenssage!);
        var updatedBudgetUsedValue = await _budgetService.UpdateUsedValue(transaction.UserId,
            transaction.TansactionDate, transaction.CategoryId, value);
        return updatedBudgetUsedValue.IsFailure ? 
            Result.Fail(updateBalanceResult.ErrorMenssage!) : Result.Ok();
    }
}