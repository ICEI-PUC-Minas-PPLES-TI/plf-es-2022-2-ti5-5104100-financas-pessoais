using WeBudgetWebAPI.DTOs;

namespace WeBudgetWebAPI.Interfaces.Sevices;

public interface IMessageBrokerService<T> where T:class
{
    public Task SendMenssage(MenssageResponse<T> mesageResponse);
}

