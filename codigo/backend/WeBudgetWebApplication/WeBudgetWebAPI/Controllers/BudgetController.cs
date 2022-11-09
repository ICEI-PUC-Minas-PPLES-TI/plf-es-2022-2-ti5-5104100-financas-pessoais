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
public class BudgetController:ControllerBase
{
    private readonly IMapper _iMapper;
    private readonly IBudget _iBudget;
    
    public BudgetController(IMapper iMapper, IBudget iBudget)
    {
        _iMapper = iMapper;
        _iBudget = iBudget;
    }
    
    [Authorize]
    [Produces("application/json")]
    [HttpPost("Add")]
    public async Task<ActionResult<Budget>> Add(BudgetRequest request)
    {
        var budget = _iMapper.Map<Budget>(request);
        var savedBudget = await _iBudget.Add(budget);
        var response = _iMapper.Map<BudgetResponse>(savedBudget);
        return Ok(response);
    }

    [Authorize]
    [HttpGet]
    public async Task<ActionResult> List()
    {
        //var userId = User.FindFirst(JwtRegisteredClaimNames.Sub).Value;
        var userId = User.FindFirst("idUsuario").Value;
        var orcamentoLista = await _iBudget.ListByUser(userId);
        if(orcamentoLista.Count == 0)
            return NotFound("Orçamentos não encontrada");
        var response = _iMapper.Map<BudgetResponse>(orcamentoLista);
        return Ok(response);
    }

    [Authorize]
    [HttpGet("{id}")]
    public async Task<ActionResult> GetById(int id)
    {
        var orcamento = await _iBudget.GetEntityById(id);
        if(orcamento==null)
            return NotFound("Orçamento não encontrado");
        var response = _iMapper.Map<BudgetResponse>(orcamento);
        return Ok(response);
    }

    [Authorize]
    [HttpPut]
    public async Task<ActionResult> Update(BudgetRequest request)
    {
        var orcamento = _iMapper.Map<Budget>(request);
        var savedOrcamento = await _iBudget.Update(orcamento);
        if (savedOrcamento == null)
            return NoContent();
        var response = _iMapper.Map<BudgetResponse>(savedOrcamento);
        return Ok(response);

    }

    [Authorize]
    [HttpDelete("{id}")]
    public async Task<ActionResult> Delete(int id)
    {
        var budget = await _iBudget.GetEntityById(id);
        if(budget==null)
            return NotFound("Orçamento não encontrada");
        await _iBudget.Delete(budget);
        return NoContent();
    }


}