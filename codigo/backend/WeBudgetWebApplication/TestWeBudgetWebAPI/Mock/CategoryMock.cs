using WeBudgetWebAPI.Interfaces;
using WeBudgetWebAPI.Models;
using WeBudgetWebAPI.Models.Entities;

namespace TestWeBudgetWebAPI.Mock;

public static class CategoryMock
{
    private static Mock<ICategory>? _categoryMock;

    public static Mock<ICategory> GetICategoryMockInstance()
    {
        return _categoryMock ??= new Mock<ICategory>();
    }

    public static void AddReturnResultOk()
    {
        if (_categoryMock != null)
            _categoryMock.Setup(x => x.Add(It.IsAny<Category>()))
                .ReturnsAsync((Category x) =>
                {
                    x.Id = 0;
                    return Result.Ok(x);
                });
    }
    public static void AddReturnResultFail()
    {
        if (_categoryMock != null)
            _categoryMock.Setup(x => x.Add(It.IsAny<Category>()))
                .ReturnsAsync(Result.Fail<Category>("Fail"));
    }

    public static void UpdateReturnResultOk()
    {
        if (_categoryMock != null)
            _categoryMock.Setup(x => x.Update(It.IsAny<Category>()))
                .ReturnsAsync((Category x) => Result.Ok(x));
    }
    public static void UpdateReturnResultFail()
    {
        if (_categoryMock != null)
            _categoryMock.Setup(x => x.Update(It.IsAny<Category>()))
                .ReturnsAsync(Result.Fail<Category>("Fail"));
    }

    public static void DeleteReturnResultOk()
    {
        if (_categoryMock != null)
            _categoryMock.Setup(x => x.Delete(It.IsAny<Category>()))
                .ReturnsAsync(Result.Ok());
    }

    public static void DeleteReturnResultFail()
    {
        if (_categoryMock != null)
            _categoryMock.Setup(x => x.Delete(It.IsAny<Category>()))
                .ReturnsAsync(Result.Fail("Fail"));
    }

    public static void ListReturnReturnResultWithCategoryList()
    {
        if (_categoryMock != null) 
            _categoryMock.Setup(x => x.List())
            .ReturnsAsync(Result.Ok(ReturnCategoryCollection()
                .ToList()));
    }
    public static void ListReturnReturnResultWithError()
    {
        if (_categoryMock != null) 
            _categoryMock.Setup(x => x.List())
                .ReturnsAsync(Result.Fail<List<Category>>("Fail"));
    }

    public static void ListByUserReturnReturnResultWithCategoryList(string userId)
    {
        if (_categoryMock != null) 
            _categoryMock.Setup(x => x.ListByUser(userId))
                .ReturnsAsync(Result.Ok(ReturnCategoryCollection().Where(x=>x.UserId==userId)
                    .ToList()));
    }

    public static void ListByUserReturnReturnResultWithError(string userId)
    {
        if (_categoryMock != null) 
            _categoryMock.Setup(x => x.ListByUser(userId))
                .ReturnsAsync(Result.Fail<List<Category>>("Fail"));
    }

    public static void GetByIdReturnResultFail(int id)
    {
        if (_categoryMock != null) 
            _categoryMock.Setup(x => x.GetEntityById(id))
                .ReturnsAsync(Result.Fail<Category>("Fail"));
    }

    public static void GetByIdReturnResultNotFound(int id)
    {
        if (_categoryMock != null) 
            _categoryMock.Setup(x => x.GetEntityById(id))
                .ReturnsAsync(Result.NotFound<Category>());
    }

    public static void GetByIdReturnResultOk(int id)
    {
        if (_categoryMock != null) 
            _categoryMock.Setup(x => x.GetEntityById(id))
                .ReturnsAsync(Result.Ok(ReturnCategoryCollection()
                    .First(x=>x.Id==id)));
    }
    private static IEnumerable<Category> ReturnCategoryCollection()
    {
        return new List<Category>()
        {
            new Category()
            {
                Id = 0,
                UserId = "0000-0000-0000-0000",
                Description = "Money",
                IconCode = 0001
            },
            new Category()
            {
                Id = 1,
                UserId = "0000-0000-0000-0000",
                Description = "Fuel",
                IconCode = 0002
            },
            new Category()
            {
                Id = 2,
                UserId = "0000-0000-0000-0000",
                Description = "Food",
                IconCode = 0003
            },
            new Category()
            {
                Id = 3,
                UserId = "0000-0000-0000-0002",
                Description = "Fishing",
                IconCode = 0004
            },
        };
    }
}