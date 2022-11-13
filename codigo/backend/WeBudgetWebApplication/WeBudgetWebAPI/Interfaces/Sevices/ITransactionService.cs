using WeBudgetWebAPI.Models;

namespace WeBudgetWebAPI.Interfaces.Sevices;

public interface ITransactionService:ITransaction
{
    Task<Transaction> Add(Transaction transaction);
    Task<Transaction> Update(Transaction transaction);
    Task Delete(Transaction transaction);
}