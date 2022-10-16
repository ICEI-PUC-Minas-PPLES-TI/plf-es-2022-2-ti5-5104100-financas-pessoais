using WeBudgetWebAPI.Interfaces.Generics;
using WeBudgetWebAPI.Models;

namespace WeBudgetWebAPI.Interfaces;

public interface IBudget:IGeneric<Budget>
{
    public Task<List<Budget>> ListByUser(string userId);
}