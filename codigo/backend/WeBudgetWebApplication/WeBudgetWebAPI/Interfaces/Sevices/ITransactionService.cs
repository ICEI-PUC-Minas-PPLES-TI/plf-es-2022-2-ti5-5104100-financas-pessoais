using WeBudgetWebAPI.Models;
using WeBudgetWebAPI.Models.Entities;

namespace WeBudgetWebAPI.Interfaces.Sevices;

public interface ITransactionService:ITransaction
{
    Task<Transaction> Add(Transaction transaction);
    Task<Transaction> Update(Transaction transaction);
    Task Delete(Transaction transaction);
}