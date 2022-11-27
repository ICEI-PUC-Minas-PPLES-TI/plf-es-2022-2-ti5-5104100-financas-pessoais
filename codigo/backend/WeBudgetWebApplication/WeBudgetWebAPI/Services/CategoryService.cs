using WeBudgetWebAPI.DTOs;
using WeBudgetWebAPI.DTOs.Response;
using WeBudgetWebAPI.Interfaces;
using WeBudgetWebAPI.Interfaces.Sevices;
using WeBudgetWebAPI.Models;
using WeBudgetWebAPI.Models.Entities;
using WeBudgetWebAPI.Models.Enums;

namespace WeBudgetWebAPI.Services;

public class CategoryService:ICategoryService
{
    private readonly ICategory _category;
    private readonly IMessageBrokerService<Category> _messageBrokerService;

    public CategoryService(ICategory category,
        IMessageBrokerService<Category> messageBrokerService)
    {
        _category = category;
        _messageBrokerService = messageBrokerService;
    }

    public async Task<Result<Category>> Add(Category category)
    {
        var addedCategoryResult = await _category.Add(category);
        if (addedCategoryResult.Success)
            await SendMenssage(OperationType.Create, addedCategoryResult.Data!);
        return addedCategoryResult;
    }

    public async Task<Result<Category>> Update(Category category)
    {
        var updatedCategoryResult = await _category.Update(category);
        if (updatedCategoryResult.Success)
            await SendMenssage(OperationType.Create, updatedCategoryResult.Data!);
        return updatedCategoryResult;
    }

    public async Task<Result> Delete(Category category)
    {
        var deletedCategoryResult = await _category.Delete(category);
        if (deletedCategoryResult.Success) 
            await SendMenssage(OperationType.Delete, category);
        return deletedCategoryResult;
    }

    public async Task<Result<Category>> GetEntityById(int id)
    {
        return await _category.GetEntityById(id);
    }

    public async Task<Result<List<Category>>> List()
    {
        return await _category.List();
    }

    public async Task<Result<List<Category>>> ListByUser(string userId)
    {
        return await _category.ListByUser(userId);
    }
    
    private Task SendMenssage(OperationType operation, Category category)
    {
        _messageBrokerService.SendMessage(TableType.Category,operation,category.UserId,category);
        return Task.CompletedTask;
    }
}