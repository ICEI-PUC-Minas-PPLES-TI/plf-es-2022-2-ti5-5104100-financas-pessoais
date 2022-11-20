using WeBudgetWebAPI.DTOs.Request;

namespace WeBudgetWebAPI.Interfaces.Sevices;

public interface IMailService
{
    Task SendEmailAsync(MailRequest mailRequest);
}