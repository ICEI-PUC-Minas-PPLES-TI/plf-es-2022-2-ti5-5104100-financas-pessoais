using System.Security.Claims;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using TestWeBudgetWebAPI.Mock;
using WeBudgetWebAPI.Controllers;
using WeBudgetWebAPI.DTOs.Request;
using WeBudgetWebAPI.DTOs.Response;
using WeBudgetWebAPI.Interfaces.Sevices;
using WeBudgetWebAPI.Models;
using WeBudgetWebAPI.Models.Entities;

namespace TestWeBudgetWebAPI.ControllersTest;

public class BudgetControllerTest
{
    private readonly BudgetController _budgetController;
    private readonly Mock<IBudgetService> _budgetServiceMock;

    public BudgetControllerTest()
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
        _budgetServiceMock = new Mock<IBudgetService>();
        var mapperMock = MapperMock.GetIMapperMockInstance();
        _budgetController = new BudgetController(mapperMock.Object,
            _budgetServiceMock.Object)
        {
            ControllerContext = controllerContext
        };
    }

    [Fact]
    public async Task Add_ShouldReturnActionResultWithBudgetResponse()
    {
        //Arrange
        var budgetRequest = new BudgetRequest()
        {
            BudgetDate = DateTime.Now,
            CategoryId = 1,
            BudgetValue = 1000.0,
            Active = false,
            UserId = "0000-0000-0000-0000",
        };
        MapperMock.BudgetRequestToBudget();
        MapperMock.BudgetToBudgetResponse();
        _budgetServiceMock.Setup(x => x.Add(It.IsAny<Budget>()))
            .ReturnsAsync((Budget x) => Result.Ok(x));
        //Act
        var actionResult = await _budgetController.Add(budgetRequest);
        //Assert
        Assert.IsAssignableFrom<OkObjectResult>(actionResult);
        var result = (OkObjectResult)actionResult;
        var value = (BudgetResponse)result.Value!;
        Assert.IsAssignableFrom<BudgetResponse>(value);
        
    }
    [Fact]
    public async Task List_ShouldReturnActionResultWithListBudgetResponse()
    {
        //Arrange
        MapperMock.BudgetListToBudgetResponseList();
        _budgetServiceMock.Setup(x => x.ListByUser(It.IsAny<string>()))
            .ReturnsAsync(Result.Ok(new List<Budget>()));
        //Act
        var actionResult = await _budgetController.List();
        //Assert
        Assert.IsAssignableFrom<OkObjectResult>(actionResult);
        var result = (OkObjectResult)actionResult;
        var value = (List<BudgetResponse>)result.Value!;
        Assert.Empty(value);

    }
    [Fact]
    public async Task GetById_ShouldReturnActionResultWithBudgetResponse()
    {
        //Arrange
        var id = 0;
        MapperMock.BudgetToBudgetResponse();
        _budgetServiceMock.Setup(x => x.GetEntityById(id))
            .ReturnsAsync(Result.Ok(new Budget()));
        //Act
        var actionResult = await _budgetController.GetById(id);
        //Assert
        Assert.IsAssignableFrom<OkObjectResult>(actionResult);
        var result = (OkObjectResult)actionResult;
        var value = (BudgetResponse)result.Value!;
        Assert.IsAssignableFrom<BudgetResponse>(value);
        
    }
    [Fact]
    public async Task Update_ShouldReturnActionResultWithBudgetResponse()
    {
        //Arrange
        var budgetRequest = new BudgetRequest()
        {
            Id = 0,
            BudgetDate = DateTime.Now,
            CategoryId = 1,
            BudgetValue = 1000.0,
            Active = false,
            UserId = "0000-0000-0000-0000",
        };
        MapperMock.BudgetRequestToBudget();
        MapperMock.BudgetToBudgetResponse();
        _budgetServiceMock.Setup(x => x.GetEntityById(It.IsAny<int>()))
            .ReturnsAsync( Result.Ok(new Budget()));
        _budgetServiceMock.Setup(x => x.Update(It.IsAny<Budget>()))
            .ReturnsAsync((Budget x) => Result.Ok(x));
        //Act
        var actionResult = await _budgetController.Update(budgetRequest);
        //Assert
        Assert.IsAssignableFrom<OkObjectResult>(actionResult);
        var result = (OkObjectResult)actionResult;
        var value = (BudgetResponse)result.Value!;
        Assert.IsAssignableFrom<BudgetResponse>(value);
        
    }
    
}