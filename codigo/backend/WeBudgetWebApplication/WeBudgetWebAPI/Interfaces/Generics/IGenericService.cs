namespace WeBudgetWebAPI.Interfaces.Generics;

public interface IGenericService<T> where T : class
{
    Task<T> Add(T Objeto);
    Task<T> Update(T Objeto);
    Task DeleteById(int Id);
    Task<T> GetEntityById(int Id);
    Task<List<T>> List();
    Task<List<T>> ListByUser(string userId);
}