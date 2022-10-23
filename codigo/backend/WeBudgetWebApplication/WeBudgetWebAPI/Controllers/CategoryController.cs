using AutoMapper;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.JsonWebTokens;
using WeBudgetWebAPI.DTOs;
using WeBudgetWebAPI.Interfaces;
using WeBudgetWebAPI.Models;

namespace WeBudgetWebAPI.Controllers;

[ApiController]
[Route("api/[controller]")]
public class CategoryController : ControllerBase
{
    private readonly IMapper _iMapper;
    private readonly ICategory _iCategory;

    public CategoryController(IMapper iMapper, ICategory iCategory)
    {
        _iMapper = iMapper;
        _iCategory = iCategory;
    }

    [Authorize]
    [Produces("application/json")]
    [HttpPost("Add")]
    public async Task<ActionResult<CategoryReponse>> Add(CategoryRequest request)
    {
        var category = _iMapper.Map<Category>(request);
        
        var savedCategory = await _iCategory.Add(category);
        var response = _iMapper.Map<CategoryReponse>(savedCategory);
        return Ok(response);
    }

    [Authorize]
    [HttpGet]
    public async Task<ActionResult> List()
    {
        var userId = User.FindFirst(JwtRegisteredClaimNames.Sub).Value;
        var categoriaLista = await _iCategory.ListByUser(userId);
        if(categoriaLista.Count == 0)
            return NotFound("Categoria não encontrada");
        var response = _iMapper.Map<List<CategoryReponse>>(categoriaLista);
        return Ok(response);
    }

    [Authorize]
    [HttpGet("{id}")]
    public async Task<ActionResult> GetById(int id)
    {
        var categoria = await _iCategory.GetEntityById(id);
        if(categoria==null)
            return NotFound("Categoria não encontrada");
        var response = _iMapper.Map<CategoryReponse>(categoria);
        return Ok(categoria);
    }

    [Authorize]
    [HttpPut]
    public async Task<ActionResult> Update(CategoryRequest request)
    {
        var categoria = _iMapper.Map<Category>(request);
        var savedCategoria =await _iCategory.Update(categoria);
        if (savedCategoria == null)
            return NoContent();
        var response = _iMapper.Map<CategoryReponse>(savedCategoria);
        return Ok(response);

    }

    [Authorize]
    [HttpDelete("{id}")]
    public async Task<ActionResult> Delete(int id)
    {
        var categoria = await _iCategory.GetEntityById(id);
        if(categoria==null)
            return NotFound("Categoria não encontrada");
        await _iCategory.Delete(categoria);
        return NoContent();
    }
    
    
    
}