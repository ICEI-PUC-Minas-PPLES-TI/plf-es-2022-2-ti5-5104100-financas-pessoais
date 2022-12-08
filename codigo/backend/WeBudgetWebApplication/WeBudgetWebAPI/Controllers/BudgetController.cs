using AutoMapper;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using WeBudgetWebAPI.DTOs.Request;
using WeBudgetWebAPI.DTOs.Response;
using WeBudgetWebAPI.Interfaces.Sevices;
using WeBudgetWebAPI.Models.Entities;

namespace WeBudgetWebAPI.Controllers;

[ApiController]
[Route("api/[controller]")]
public class BudgetController:ControllerBase
{
    private readonly IMapper _iMapper;
    private readonly IBudgetService _budgetService;


    public BudgetController(IMapper iMapper, IBudgetService budgetService)
    {
        _iMapper = iMapper;
        _budgetService = budgetService;
    }

    [Authorize]
    [Produces("application/json")]
    [HttpPost("Add")]
    public async Task<ActionResult> Add(BudgetRequest request)
    {
        var budget = _iMapper.Map<Budget>(request);
        var savedBudgetResult = await _budgetService.Add(budget);
        if(savedBudgetResult.IsFailure)
            return StatusCode(500, savedBudgetResult.ErrorMenssage);
        var response = _iMapper.Map<BudgetResponse>(savedBudgetResult.Data);
        return Ok(response);
    }

    [Authorize]
    [HttpGet]
    public async Task<ActionResult> List()
    {
        var userId = User.FindFirst("idUsuario")!.Value;
        var budgetListResult = await _budgetService.ListByUser(userId);
        if(budgetListResult.IsFailure)
            return StatusCode(500, budgetListResult.ErrorMenssage);
        var response = _iMapper.Map<List<BudgetResponse>>(budgetListResult.Data);
        return Ok(response);
    }

    [Authorize]
    [HttpGet("{id}")]
    public async Task<ActionResult> GetById(int id)
    {
        var budgetResult = await _budgetService.GetEntityById(id);
        if(budgetResult.IsFailure)
            return StatusCode(500, budgetResult.ErrorMenssage);
        if (budgetResult.NotFound)
            return NotFound();
        var response = _iMapper.Map<BudgetResponse>(budgetResult.Data);
        return Ok(response);
    }

    [Authorize]
    [HttpPut]
    public async Task<ActionResult> Update(BudgetRequest request)
    {
        var budget = _iMapper.Map<Budget>(request);
        var savedBudgetResult = await _budgetService.GetEntityById(budget.Id);
        if(savedBudgetResult.IsFailure)
            return StatusCode(500, savedBudgetResult.ErrorMenssage);
        if (savedBudgetResult.NotFound)
            return NotFound();
        budget.BudgetValueUsed = savedBudgetResult.Data!.BudgetValueUsed;
        var updatedBudgetResult = await _budgetService.Update(budget);
        if(updatedBudgetResult.IsFailure)
            return StatusCode(500, updatedBudgetResult.ErrorMenssage);
        var response = _iMapper.Map<BudgetResponse>(updatedBudgetResult.Data);
        return Ok(response);
    }

    [Authorize]
    [HttpDelete("{id}")]
    public async Task<ActionResult> Delete(int id)
    {
        var budgetResult = await _budgetService.GetEntityById(id);
        if(budgetResult.IsFailure)
            return StatusCode(500, budgetResult.ErrorMenssage);
        if (budgetResult.NotFound)
            return NotFound();
        var deletedBudgetResult = await _budgetService.Delete(budgetResult.Data!);
        if(deletedBudgetResult.IsFailure)
            return StatusCode(500, deletedBudgetResult.ErrorMenssage);
        return NoContent();
    }


}