using WeBudgetWebAPI.DTOs;
using WeBudgetWebAPI.DTOs.Response;
using WeBudgetWebAPI.Interfaces;
using WeBudgetWebAPI.Interfaces.Sevices;
using WeBudgetWebAPI.Models;
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

    public async Task<Category> Add(Category category)
    {
        return await SendMenssage(OperationType.Create,
            await _category.Add(category));
    }

    public async Task<Category> Update(Category category)
    {
        return await SendMenssage(OperationType.Update,
            await _category.Update(category));;
    }

    public async Task Delete(Category category)
    {
        await _category.Delete(category);
        await SendMenssage(OperationType.Delete, category);
    }

    public async Task<Category?> GetEntityById(int id)
    {
        return await _category.GetEntityById(id);
    }

    public async Task<List<Category>> List()
    {
        return await _category.List();
    }

    public async Task<List<Category>> ListByUser(string userId)
    {
        return await _category.ListByUser(userId);
    }
    
    private async Task<Category> SendMenssage(OperationType operation, Category category)
    {
        return await _messageBrokerService.SendMenssage(new MenssageResponse<Category>()
        {
            Table = TableType.Category,
            UserId = category.UserId,
            Operation = operation,
            Object = category
        });
    }
}