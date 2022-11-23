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

    public async Task<Budget?> UpdateUsedValue(string userId, DateTime dateTime,
        int categoryId, double value)
    {
        var savedBudget = await _iBudget
            .GetByUserTimeAndCategory(userId, dateTime, categoryId);
        
        if (savedBudget == null)
        {
            savedBudget = await CreateRecurrentBudget(userId, dateTime, categoryId);
            
            if (savedBudget == null)
                return null;
        }
        savedBudget.BudgetValueUsed -= value;
        
        return await SendMenssage(OperationType.Update, 
            await _iBudget.Update(savedBudget));
    }

    public async Task<Budget?> CreateRecurrentBudget(string userId, DateTime dateTime,
        int categoryId)
    {
        var lastMonthBudget = await _iBudget
            .GetByUserTimeAndCategory(userId, dateTime.AddMonths(-1),
                categoryId);
        
        if (lastMonthBudget == null || lastMonthBudget.Active==false)
            return null;
        
        return await SendMenssage(OperationType.Create,
            await _iBudget.Add(new Budget()
        {
            UserId = userId,
            BudgetDate = dateTime,
            CategoryId = categoryId

        }));

    }

    public async Task<Budget> Add(Budget budget)
    {
        var usedValue = await _iTransaction.SumTransaction(budget.UserId,
            budget.BudgetDate);
        budget.BudgetValueUsed = -usedValue;
        return await SendMenssage(OperationType.Create,
            await _iBudget.Add(budget));
    }

    public async Task<Budget> Update(Budget budget)
    {
        return await SendMenssage(OperationType.Update,
            await _iBudget.Update(budget));
    }

    public async Task Delete(Budget budget)
    {
        await _iBudget.Delete(budget);
        await SendMenssage(OperationType.Delete, budget);
    }

    public async Task<Budget?> GetEntityById(int id)
    {
        return await _iBudget.GetEntityById(id);
    }

    public async Task<List<Budget>> List()
    {
        return await _iBudget.List();
    }

    public async Task<List<Budget>> ListByUser(string userId)
    {
        return await _iBudget.ListByUser(userId);
    }

    public async Task<List<Budget>> ListByUserAndTime(string userId, DateTime dateTime)
    {
        return await _iBudget.ListByUserAndTime(userId, dateTime);
    }

    public async Task<Budget?> GetByUserTimeAndCategory(string userId, DateTime dateTime, int categoryId)
    {
        return await _iBudget.GetByUserTimeAndCategory(userId, dateTime, categoryId);
    }

    private async Task<Budget> SendMenssage(OperationType operation, Budget budget)
    {
        return await _messageBrokerService.SendMenssage(new MenssageResponse<Budget>()
        {
            Table = TableType.Budget,
            UserId = budget.UserId,
            Operation = operation,
            Object = budget
        });
    }
}