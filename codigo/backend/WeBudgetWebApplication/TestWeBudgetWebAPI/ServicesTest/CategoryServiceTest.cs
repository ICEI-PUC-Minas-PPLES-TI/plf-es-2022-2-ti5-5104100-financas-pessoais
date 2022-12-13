using TestWeBudgetWebAPI.Mock;
using WeBudgetWebAPI.Interfaces;
using WeBudgetWebAPI.Interfaces.Sevices;
using WeBudgetWebAPI.Models.Entities;
using WeBudgetWebAPI.Services;

namespace TestWeBudgetWebAPI.ServicesTest;

public class CategoryServiceTest
{
    private readonly CategoryService _categoryService;
    private readonly Mock<ICategory> _categoryMock;

    public CategoryServiceTest()
    {
        var messageMock = new Mock<IMessageBrokerService<Category>>();
        _categoryMock = CategoryMock.GetICategoryMockInstance();
        _categoryService = new CategoryService(_categoryMock.Object,
            messageMock.Object);
    }
    [Fact]
    public async Task Add_ShouldReturnAReturnWithCategory()
    {
        //Arrange
        var category = new Category()
        {
            UserId = "0000-0000-0000-0000",
            Description = "Money",
            IconCode = 0001
        };
        CategoryMock.AddReturnResultOk();
        //Act
        var resultCategory = await _categoryService.Add(category);
        //Assert
        Assert.True(resultCategory.Success);
        Assert.False(resultCategory.IsFailure);
        Assert.False(resultCategory.NotFound);
        Assert.Equal(0, resultCategory.Data!.Id);
    }
    [Fact]
    public async Task Add_ShouldReturnAReturnWithError()
    {
        //Arrange
        var category = new Category()
        {
            UserId = "0000-0000-0000-0000",
            Description = "Money",
            IconCode = 0001
        };
        CategoryMock.AddReturnResultFail();
        //Act
        var resultCategory = await _categoryService.Add(category);
        //Assert
        Assert.False(resultCategory.Success);
        Assert.True(resultCategory.IsFailure);
        Assert.False(resultCategory.NotFound);
        Assert.Equal("Fail", resultCategory.ErrorMenssage);
    }
    [Fact]
    public async Task Update_ShouldReturnAReturnWithCategory()
    {
        //Arrange
        var category = new Category()
        {
            Id = 0,
            UserId = "0000-0000-0000-0000",
            Description = "Money",
            IconCode = 0001
        };
        CategoryMock.UpdateReturnResultOk();
        //Act
        var resultCategory = await _categoryService.Update(category);
        //Assert
        Assert.True(resultCategory.Success);
        Assert.False(resultCategory.IsFailure);
        Assert.False(resultCategory.NotFound);
        Assert.Equal(0, resultCategory.Data!.Id);
    }
    [Fact]
    public async Task Update_ShouldReturnAReturnWithError()
    {
        //Arrange
        var category = new Category()
        {
            Id = 0,
            UserId = "0000-0000-0000-0000",
            Description = "Money",
            IconCode = 0001
        };
        CategoryMock.UpdateReturnResultFail();
        //Act
        var resultCategory = await _categoryService.Update(category);
        //Assert
        Assert.False(resultCategory.Success);
        Assert.True(resultCategory.IsFailure);
        Assert.False(resultCategory.NotFound);
        Assert.Equal("Fail",
            resultCategory.ErrorMenssage);
    }
    [Fact]
    public async Task Delete_ShouldReturnAReturnWithSuccess()
    {
        //Arrange
        var category = new Category();
        CategoryMock.DeleteReturnResultOk();
        //Act
        var deleteResult = await _categoryService.Delete(category);
        //Assert
        Assert.True(deleteResult.Success);
        Assert.False(deleteResult.IsFailure);
    }
    [Fact]
    public async Task Delete_ShouldReturnAReturnWithErrorMessage()
    {
        //Arrange
        var category = new Category();
        CategoryMock.DeleteReturnResultFail();
        //Act
        var deleteResult = await _categoryService.Delete(category);
        //Assert
        Assert.False(deleteResult.Success);
        Assert.True(deleteResult.IsFailure);
        Assert.Equal("Fail",
            deleteResult.ErrorMenssage);
    }
    [Fact]
    public async Task List_ShouldReturnAReturnWithAccountList()
    {
        //Arrange
        CategoryMock.ListReturnReturnResultWithCategoryList();
        //Act
        var resultList = await _categoryService.List();
        //Assert
        Assert.True(resultList.Success);
        Assert.False(resultList.IsFailure);
        Assert.Equal(4, resultList.Data!.Count);
    }
    [Fact]
    public async Task List_ShouldReturnAReturnWithErrorMessage()
    {
        //Arrange
        CategoryMock.ListReturnReturnResultWithError();
        //Act
        var resultList = await _categoryService.List();
        //Assert
        Assert.False(resultList.Success);
        Assert.True(resultList.IsFailure);
        Assert.Equal("Fail",
            resultList.ErrorMenssage);
    }
    [Fact]
    public async Task ListByUser_ShouldReturnAReturnWithAccountList()
    {
        //Arrange
        var userId = "0000-0000-0000-0000";
        CategoryMock.ListByUserReturnReturnResultWithCategoryList(userId);
        //Act
        var resultList = await _categoryService.ListByUser(userId);
        //Assert
        Assert.True(resultList.Success);
        Assert.False(resultList.IsFailure);
        Assert.Equal(3, resultList.Data!.Count);
    }
    [Fact]
    public async Task ListByUser_ShouldReturnAReturnWithErrorMessage()
    {
        //Arrange
        var userId = "0000-0000-0000-0000";
        CategoryMock.ListByUserReturnReturnResultWithError(userId);
        //Act
        var resultList = await _categoryService.ListByUser(userId);
        //Assert
        Assert.False(resultList.Success);
        Assert.True(resultList.IsFailure);
        Assert.Equal("Fail",
            resultList.ErrorMenssage);
    }
    [Fact]
    public async Task GetById_ShouldReturnAReturnWithAccount()
    {
        //Arrange
        var id = 0;
        CategoryMock.GetByIdReturnResultOk(id);
        //Act
        var resultCategory = await _categoryService.GetEntityById(id);
        //Assert
        Assert.True(resultCategory.Success);
        Assert.False(resultCategory.IsFailure);
        Assert.Equal(id, resultCategory.Data!.Id);
    }
    [Fact]
    public async Task GetById_ShouldReturnAReturnWithErrorMessage()
    {
        //Arrange
        var id = 0;
        CategoryMock.GetByIdReturnResultFail(id);
        //Act
        var resultCategory = await _categoryService.GetEntityById(id);
        //Assert
        Assert.False(resultCategory.Success);
        Assert.True(resultCategory.IsFailure);
        Assert.Equal("Fail",
            resultCategory.ErrorMenssage);
    }
    [Fact]
    public async Task GetById_ShouldReturnAReturnWithNotFound()
    {
        //Arrange
        var id = 0;
        CategoryMock.GetByIdReturnResultNotFound(id);
        //Act
        var resultCategory = await _categoryService.GetEntityById(id);
        //Assert
        Assert.True(resultCategory.Success);
        Assert.False(resultCategory.IsFailure);
        Assert.True(resultCategory.NotFound);
    }
}