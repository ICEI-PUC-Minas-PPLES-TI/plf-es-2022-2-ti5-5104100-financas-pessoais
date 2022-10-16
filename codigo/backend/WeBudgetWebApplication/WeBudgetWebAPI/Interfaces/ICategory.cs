using WeBudgetWebAPI.Interfaces.Generics;
using WeBudgetWebAPI.Models;

namespace WeBudgetWebAPI.Interfaces;

public interface ICategory : IGeneric<Category>
{
    public Task<List<Category>> ListByUser(string userId);
}