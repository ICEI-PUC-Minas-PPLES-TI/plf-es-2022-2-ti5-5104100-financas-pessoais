using WeBudgetWebAPI.DTOs;
using WeBudgetWebAPI.DTOs.Response;

namespace WeBudgetWebAPI.Interfaces.Sevices;

public interface IMessageBrokerService<T> where T:class
{
    public Task<T> SendMenssage(MenssageResponse<T> mesageResponse);
}

