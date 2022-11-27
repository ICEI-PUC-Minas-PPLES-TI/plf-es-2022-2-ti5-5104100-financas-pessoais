using AutoMapper;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using WeBudgetWebAPI.DTOs;
using WeBudgetWebAPI.DTOs.Request;
using WeBudgetWebAPI.DTOs.Response;
using WeBudgetWebAPI.Interfaces;
using WeBudgetWebAPI.Interfaces.Sevices;
using WeBudgetWebAPI.Models;
using WeBudgetWebAPI.Models.Entities;

namespace WeBudgetWebAPI.Controllers;

[ApiController]
[Route("api/[controller]")]
public class CategoryController : ControllerBase
{
    private readonly IMapper _iMapper;
    private readonly ICategoryService _categoryService;


    public CategoryController(IMapper iMapper, ICategoryService categoryService)
    {
        _iMapper = iMapper;
        _categoryService = categoryService;
    }

    [Authorize]
    [Produces("application/json")]
    [HttpPost("Add")]
    public async Task<ActionResult<CategoryResponse>> Add(CategoryRequest request)
    {
        var category = _iMapper.Map<Category>(request);
        var savedCategoryResult = await _categoryService.Add(category);
        if(savedCategoryResult.IsFailure)
            return StatusCode(500, savedCategoryResult.ErrorMenssage);
        var response = _iMapper.Map<CategoryResponse>(savedCategoryResult.Data);
        return Ok(response);
    }

    [Authorize]
    [HttpGet]
    public async Task<ActionResult> List()
    {
        var userId = User.FindFirst("idUsuario")!.Value;
        var categoryListResult = await _categoryService.ListByUser(userId);
        if(categoryListResult.IsFailure)
            return StatusCode(500, categoryListResult.ErrorMenssage);
        var response = _iMapper.Map<List<CategoryResponse>>(categoryListResult.Data);
        return Ok(response);
    }

    [Authorize]
    [HttpGet("{id}")]
    public async Task<ActionResult> GetById(int id)
    {
        var categoryResult = await _categoryService.GetEntityById(id);
        if(categoryResult.IsFailure)
            return StatusCode(500, categoryResult.ErrorMenssage);
        if (categoryResult.NotFound)
            return NotFound();
        var response = _iMapper.Map<CategoryResponse>(categoryResult.Data);
        return Ok(response);
    }

    [Authorize]
    [HttpPut]
    public async Task<ActionResult> Update(CategoryRequest request)
    {
        var category = _iMapper.Map<Category>(request);
        var savedCategoryResult =await _categoryService.GetEntityById(category.Id);
        if(savedCategoryResult.IsFailure)
            return StatusCode(500, savedCategoryResult.ErrorMenssage);
        if (savedCategoryResult.NotFound)
            return NotFound();
        var updatedCategoryResult = await _categoryService.Update(category);
        if(savedCategoryResult.IsFailure)
            return StatusCode(500, updatedCategoryResult.ErrorMenssage);
        var response = _iMapper.Map<CategoryResponse>(updatedCategoryResult.Data);
        return Ok(response);
    }

    [Authorize]
    [HttpDelete("{id}")]
    public async Task<ActionResult> Delete(int id)
    {
        var savedCategoryResult = await _categoryService.GetEntityById(id);
        if(savedCategoryResult.IsFailure)
            return StatusCode(500, savedCategoryResult.ErrorMenssage);
        if (savedCategoryResult.NotFound)
            return NotFound();
        var deletedCategoryResult = await _categoryService.Delete(savedCategoryResult.Data!);
        if(deletedCategoryResult.IsFailure)
            return StatusCode(500, savedCategoryResult.ErrorMenssage);
        return NoContent();
    }
    
    
    
}