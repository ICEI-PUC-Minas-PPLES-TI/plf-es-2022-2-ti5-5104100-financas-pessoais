using System.Security.Claims;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using TestWeBudgetWebAPI.Mock;
using WeBudgetWebAPI.Controllers;
using WeBudgetWebAPI.Interfaces.Sevices;
using WeBudgetWebAPI.Models;
using WeBudgetWebAPI.Models.Entities;
using WeBudgetWebAPI.Services;

namespace TestWeBudgetWebAPI.ControllersTest;

public class AccountControllerTest
{
    private readonly AccountController _accountController;
    private readonly Mock<IAccountService> _accountServiceMock;

    public AccountControllerTest()
    {
        var claims = new List<Claim>() 
        { 
            new Claim(ClaimTypes.Name, "username"),
            new Claim(ClaimTypes.NameIdentifier, "userId"),
            new Claim("idUsuario", "0000-0000-0000-0000"),
        };
        var identity = new ClaimsIdentity(claims, "TestAuthType");
        var claimsPrincipal = new ClaimsPrincipal(identity); ;
        var httpContextMock = new Mock<HttpContext>();
        httpContextMock.Setup(x => x.User).Returns(claimsPrincipal);
        var controllerContext = new ControllerContext() {
            HttpContext = httpContextMock.Object
        };
        _accountServiceMock = new Mock<IAccountService>();
        _accountController = new AccountController(_accountServiceMock.Object)
        {
            ControllerContext = controllerContext
        };
    }

    [Fact]
    public async Task List_ShouldReturnActionResultWithList()
    {
        //Arrange
        _accountServiceMock.Setup(x => x.ListByUser(It.IsAny<string>()))
            .ReturnsAsync(Result.Ok(AccountMock.ReturnAccountList(DateTime.Now)
                .ToList()));
        //Act
        var actionResult = await _accountController.List();
        //Assert
        Assert.IsAssignableFrom<OkObjectResult>(actionResult);
        var result = (OkObjectResult)actionResult;
        var value = (List<Account>)result.Value!;
        Assert.Equal(4,value.Count);
    }
    [Fact]
    public async Task GetById_ShouldReturnActionResultWithAccount()
    {
        //Arrange
        var id = 0;
        var account = new Account()
        {
            Id=id,
            UserId = "0000-0000-0000-0000",
            AccountBalance = 0.0,
            AccountDateTime = DateTime.Now
        };
        _accountServiceMock.Setup(x => x.GetEntityById(id))
            .ReturnsAsync(Result.Ok(account));
        //Act
        var actionResult = await _accountController.GetById(id);
        //Assert
        Assert.IsAssignableFrom<OkObjectResult>(actionResult);
        var result = (OkObjectResult)actionResult;
        var value = (Account)result.Value!;
        Assert.Equal(0,value.Id);
    }
   

}