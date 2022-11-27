using WeBudgetWebAPI.DTOs;
using WeBudgetWebAPI.DTOs.Response;
using WeBudgetWebAPI.Interfaces;
using WeBudgetWebAPI.Interfaces.Sevices;
using WeBudgetWebAPI.Models;
using WeBudgetWebAPI.Models.Entities;
using WeBudgetWebAPI.Models.Enums;

namespace WeBudgetWebAPI.Services;

public class BudgetService:IBudgetService
{
    private readonly IBudget _iBudget;
    private readonly ITransaction _iTransaction;
    private readonly IMessageBrokerService<Budget> _messageBrokerService;

    public BudgetService(IBudget iBudget, IMessageBrokerService<Budget> messageBrokerService,
        ITransaction iTransaction)
    {
        _iBudget = iBudget;
        _messageBrokerService = messageBrokerService;
        _iTransaction = iTransaction;
    }
    public async Task<Result<Budget>> UpdateUsedValue(string userId, DateTime dateTime,
        int categoryId, double value)
    {
        var savedBudgetResult = await _iBudget
            .GetByUserTimeAndCategory(userId, dateTime, categoryId);
        if (savedBudgetResult.IsFailure)
            return savedBudgetResult;
        if (savedBudgetResult.NotFound!)
        {
            savedBudgetResult = await CreateRecurrentBudget(userId, dateTime, categoryId);
            if (savedBudgetResult.IsFailure)
                return savedBudgetResult;
        }
        savedBudgetResult.Data!.BudgetValueUsed -= value;
        var updatedBudgetResult = await _iBudget.Update(savedBudgetResult.Data!);
        if (updatedBudgetResult.IsFailure)
            return updatedBudgetResult;
        await SendMessage(OperationType.Update, updatedBudgetResult.Data!);
        return updatedBudgetResult;
    }
    public async Task<Result<Budget>> CreateRecurrentBudget(string userId, DateTime dateTime,
        int categoryId)
    {
        var lastMonthBudgetResult = await _iBudget
            .GetByUserTimeAndCategory(userId, dateTime.AddMonths(-1),
                categoryId);
        if (lastMonthBudgetResult.IsFailure || lastMonthBudgetResult.NotFound)
            return lastMonthBudgetResult;
        if (lastMonthBudgetResult.Data!.Active == false)
            return Result.NotFound<Budget>();
        var cratedBudgetResult = await _iBudget.Add(new Budget()
        {
            UserId = userId,
            BudgetDate = dateTime,
            CategoryId = categoryId

        });
        if (cratedBudgetResult.IsFailure)
            return cratedBudgetResult;
        await SendMessage(OperationType.Create,cratedBudgetResult.Data!);
        return cratedBudgetResult;
    }
    public async Task<Result<Budget>> Add(Budget budget)
    {
        var usedValueResult = await _iTransaction.SumTransaction(budget.UserId,
            budget.BudgetDate);
        if (usedValueResult.IsFailure)
            return Result.Fail<Budget>(usedValueResult.ErrorMenssage!);
        budget.BudgetValueUsed = -usedValueResult.Data;
        var addedBudgetResult = await _iBudget.Add(budget);
        if (addedBudgetResult.IsFailure)
            return Result.Fail<Budget>(addedBudgetResult.ErrorMenssage!);
        await SendMessage(OperationType.Create, addedBudgetResult.Data!);
        return addedBudgetResult;
    }

    public async Task<Result<Budget>> Update(Budget budget)
    {
        var updatedBudgetResult = await _iBudget.Update(budget);
        if (updatedBudgetResult.IsFailure)
            return updatedBudgetResult;
        await SendMessage(OperationType.Update, updatedBudgetResult.Data!);
        return updatedBudgetResult;
    }

    public async Task<Result> Delete(Budget budget)
    {
        var deleteResult = await _iBudget.Delete(budget);
        if (deleteResult.IsFailure)
            return deleteResult;
        await SendMessage(OperationType.Delete, budget);
        return deleteResult;
    }

    public async Task<Result<Budget>> GetEntityById(int id)
    {
        return await _iBudget.GetEntityById(id);
    }

    public async Task<Result<List<Budget>>> List()
    {
        return await _iBudget.List();
    }

    public async Task<Result<List<Budget>>> ListByUser(string userId)
    {
        return await _iBudget.ListByUser(userId);
    }

    public async Task<Result<List<Budget>>> ListByUserAndTime(string userId, DateTime dateTime)
    {
        return await _iBudget.ListByUserAndTime(userId, dateTime);
    }

    public async Task<Result<Budget>> GetByUserTimeAndCategory(string userId, DateTime dateTime,
        int categoryId)
    {
        return await _iBudget.GetByUserTimeAndCategory(userId, dateTime, categoryId);
    }

    private Task SendMessage(OperationType operation, Budget budget)
    {
        _messageBrokerService.SendMessage(TableType.Budget,operation,budget.UserId,budget);
        return Task.CompletedTask;
    }
}