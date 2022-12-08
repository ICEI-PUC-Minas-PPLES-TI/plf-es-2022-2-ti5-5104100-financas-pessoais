using WeBudgetWebAPI.Models;

namespace WeBudgetWebAPI.Interfaces.Generics;

public interface IGeneric<T> where T : class
{
    Task<Result<T>> Add(T Objeto);
    Task<Result<T>> Update(T Objeto);
    Task<Result> Delete(T Objeto);
    Task<Result<T>> GetEntityById(int Id);
    Task<Result<List<T>>> List();
}