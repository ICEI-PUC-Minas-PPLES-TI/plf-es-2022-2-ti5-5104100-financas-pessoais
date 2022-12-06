using AutoMapper;
using WeBudgetWebAPI.DTOs.Request;
using WeBudgetWebAPI.DTOs.Response;
using WeBudgetWebAPI.Models.Entities;

namespace TestWeBudgetWebAPI.Mock;

public static class MapperMock
{
    private static Mock<IMapper>? _mapperMock;
    public static Mock<IMapper> GetIMapperMockInstance()
    {
        return _mapperMock ??= new Mock<IMapper>();
    }

    public static void BudgetRequestToBudget()
    {
        if (_mapperMock != null)
            _mapperMock.Setup(x => x.Map<Budget>(It.IsAny<BudgetRequest>()))
                .Returns(GetBudget());
    }
    public static void BudgetToBudgetResponse()
    {
        if (_mapperMock != null)
            _mapperMock.Setup(x => x.Map<BudgetResponse>(It.IsAny<Budget>()))
                .Returns(GetBudgetResponse());
    }
    private static Budget GetBudget()
    {
        return new Budget()
        {
            Id = 0,
            UserId = "0000-0000-0000-0000",
            BudgetDate = DateTime.Now,
            Active = true,
            CategoryId = 1,
            BudgetValue = 1000.0,
            BudgetValueUsed = 0.0

        };
    }
    private static BudgetResponse GetBudgetResponse()
    {
        return new BudgetResponse()
        {
            Id = 0,
            UserId = "0000-0000-0000-0000",
            BudgetDate = DateTime.Now,
            Active = true,
            CategoryId = 1,
            BudgetValue = 1000.0,
            BudgetValueUsed = 0.0

        };
    }

    public static void BudgetListToBudgetResponseList()
    {
        if (_mapperMock != null)
            _mapperMock.Setup(x => x.Map<List<BudgetResponse>>(It.IsAny<List<Budget>>()))
                .Returns(new List<BudgetResponse>());
    }
}