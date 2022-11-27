using WeBudgetWebAPI.DTOs;
using WeBudgetWebAPI.DTOs.Response;
using WeBudgetWebAPI.Models;
using WeBudgetWebAPI.Models.Enums;

namespace WeBudgetWebAPI.Interfaces.Sevices;

public interface IMessageBrokerService<T> where T:class
{
    Task SendMessage(TableType table, OperationType operation,
        string userId, T data);
}

