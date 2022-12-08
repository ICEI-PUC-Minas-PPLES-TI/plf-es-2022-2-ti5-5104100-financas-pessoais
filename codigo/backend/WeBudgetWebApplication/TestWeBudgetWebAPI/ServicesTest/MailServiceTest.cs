using System.Net.Mail;
using Microsoft.Extensions.Options;
using WeBudgetWebAPI.Configurations;
using WeBudgetWebAPI.DTOs.Request;
using WeBudgetWebAPI.Services;

namespace TestWeBudgetWebAPI.ServicesTest;

public class MailServiceTest
{

    [Fact]
    public async Task SendEmailAsync_ShouldReturnException()
    {
        //Arrange
        var mailSettings = new MailSettings()
        {
            DisplayName = "Test",
            Host = "smt.test",
            Password = "test",
            Mail = "tese@test.com",
            Port = 555
        };
        var options = Options.Create(mailSettings);
        var mailService = new MailService(options);
        var mailRequest = new MailRequest()
        {
            ToEmail = "test@test.com"
        };
        //Act e Assert
        await Assert.ThrowsAsync<SmtpException>(() => mailService.SendEmailAsync(mailRequest));
    }
}