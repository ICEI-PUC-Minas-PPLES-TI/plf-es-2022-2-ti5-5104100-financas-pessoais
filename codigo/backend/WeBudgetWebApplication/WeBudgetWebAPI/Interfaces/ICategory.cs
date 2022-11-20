using WeBudgetWebAPI.Interfaces.Generics;
using WeBudgetWebAPI.Models;
using WeBudgetWebAPI.Models.Entities;

namespace WeBudgetWebAPI.Interfaces;

public interface ICategory : IGeneric<Category>
{
    public Task<List<Category>> ListByUser(string userId);
}