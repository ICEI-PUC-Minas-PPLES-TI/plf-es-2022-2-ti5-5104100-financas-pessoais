using AutoMapper;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.JsonWebTokens;
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
    public async Task<ActionResult<Budget>> Add(BudgetRequest request)
    {
        var budget = _iMapper.Map<Budget>(request);
        var savedBudget = await _budgetService.Add(budget);
        var response = _iMapper.Map<BudgetResponse>(savedBudget);
        return Ok(response);
    }

    [Authorize]
    [HttpGet]
    public async Task<ActionResult> List()
    {
        var userId = User.FindFirst("idUsuario")!.Value;
        var orcamentoLista = await _budgetService.ListByUser(userId);
        if(orcamentoLista.Count == 0)
            return NotFound("Orçamentos não encontrada");
        var response = _iMapper.Map<List<BudgetResponse>>(orcamentoLista);
        return Ok(response);
    }

    [Authorize]
    [HttpGet("{id}")]
    public async Task<ActionResult> GetById(int id)
    {
        var orcamento = await _budgetService.GetEntityById(id);
        if(orcamento==null)
            return NotFound("Orçamento não encontrado");
        var response = _iMapper.Map<BudgetResponse>(orcamento);
        return Ok(response);
    }

    [Authorize]
    [HttpPut]
    public async Task<ActionResult> Update(BudgetRequest request)
    {
        var budget = _iMapper.Map<Budget>(request);
        var savedBudget = await _budgetService.GetEntityById(budget.Id);
        if (savedBudget == null)
            return NotFound("Orçamento não encontrada");
        var updatedBudget = await _budgetService.Update(budget);
        var response = _iMapper.Map<BudgetResponse>(updatedBudget);
        return Ok(response);

    }

    [Authorize]
    [HttpDelete("{id}")]
    public async Task<ActionResult> Delete(int id)
    {
        var budget = await _budgetService.GetEntityById(id);
        if(budget==null)
            return NotFound("Orçamento não encontrada");
        await _budgetService.Delete(budget);
        return NoContent();
    }


}