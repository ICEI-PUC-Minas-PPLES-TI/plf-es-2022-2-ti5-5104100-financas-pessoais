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
        var savedCategory = await _categoryService.Add(category);
        var response = _iMapper.Map<CategoryResponse>(savedCategory);
        return Ok(response);
    }

    [Authorize]
    [HttpGet]
    public async Task<ActionResult> List()
    {
        var userId = User.FindFirst("idUsuario")!.Value;
        var categoryList = await _categoryService.ListByUser(userId);
        var response = _iMapper.Map<List<CategoryResponse>>(categoryList);
        return Ok(response);
    }

    [Authorize]
    [HttpGet("{id}")]
    public async Task<ActionResult> GetById(int id)
    {
        var category = await _categoryService.GetEntityById(id);
        if(category==null)
            return NotFound("Categoria não encontrada");
        var response = _iMapper.Map<CategoryResponse>(category);
        return Ok(response);
    }

    [Authorize]
    [HttpPut]
    public async Task<ActionResult> Update(CategoryRequest request)
    {
        var category = _iMapper.Map<Category>(request);
        var savedCategory =await _categoryService.GetEntityById(category.Id);
        if (savedCategory == null)
            return NoContent();
        var updatedCategory = await _categoryService.Update(category);
        var response = _iMapper.Map<CategoryResponse>(updatedCategory);
        return Ok(response);

    }

    [Authorize]
    [HttpDelete("{id}")]
    public async Task<ActionResult> Delete(int id)
    {
        var response = await _categoryService.GetEntityById(id);
        if(response==null)
            return NotFound("Categoria não encontrada");
        await _categoryService.Delete(response);
        return NoContent();
    }
    
    
    
}