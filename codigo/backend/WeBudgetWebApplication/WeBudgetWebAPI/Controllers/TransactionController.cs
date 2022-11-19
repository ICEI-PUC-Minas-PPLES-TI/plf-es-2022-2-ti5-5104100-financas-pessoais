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

namespace WeBudgetWebAPI.Controllers;

[ApiController]
[Route("api/[controller]")]
public class TransactionController:ControllerBase
{
    private readonly IMapper _iMapper;
    private readonly ITransactionService _iTransactionService;

    public TransactionController(IMapper iMapper, ITransactionService iTransactionService)
    {
        _iMapper = iMapper;
        _iTransactionService = iTransactionService;
    }
    
    [Authorize]
    [Produces("application/json")]
    [HttpPost("Add")]
    public async Task<ActionResult<TransactionResponse>> Add(TransactionRequest request)
    {
        var transaction = _iMapper.Map<Transaction>(request);
        var savedTrasation = await _iTransactionService.Add(transaction);
        var response = _iMapper.Map<TransactionResponse>(savedTrasation);
        return Ok(response);
    }
    
    [Authorize]
    [HttpGet]
    public async Task<ActionResult> List()
    {
        var userId = User.FindFirst("idUsuario")!.Value;
        var transactionList = await _iTransactionService.ListByUser(userId);
        if(transactionList.Count == 0)
            return NotFound("Transacões não encontradas");
        var response = _iMapper.Map<List<TransactionResponse>>(transactionList);
        return Ok(response);
    }

    [Authorize]
    [HttpGet("{id}")]
    public async Task<ActionResult> GetById(int id)
    {
        var transaction = await _iTransactionService.GetEntityById(id);
        if(transaction==null)
            return NotFound("Transacão não encontrada");
        var response = _iMapper.Map<TransactionResponse>(transaction);
        return Ok(response);
    }
    [Authorize]
    [HttpPut]
    public async Task<ActionResult> Update(TransactionRequest request)
    {
        var transaction = _iMapper.Map<Transaction>(request);
        var savedTransaction = await _iTransactionService.GetEntityById(transaction.Id);
        if (savedTransaction == null)
            return NoContent();
        var updatedTransaction = await _iTransactionService.Update(transaction);
        var response = _iMapper.Map<TransactionResponse>(savedTransaction);
        return Ok(response);

    }
    [Authorize]
    [HttpDelete("{id}")]
    public async Task<ActionResult> Delete(int id)
    {
        var transaction = await _iTransactionService.GetEntityById(id);
        if(transaction==null)
            return NotFound("Categoria não encontrada");
        await _iTransactionService.Delete(transaction);
        return NoContent();
    }
}