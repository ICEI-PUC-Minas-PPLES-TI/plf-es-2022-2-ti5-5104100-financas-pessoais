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
        var savedTransactionResult = await _iTransactionService.Add(transaction);
        if(savedTransactionResult.IsFailure)
            return StatusCode(500, savedTransactionResult.ErrorMenssage);
        var response = _iMapper.Map<TransactionResponse>(savedTransactionResult.Data);
        return Ok(response);
    }
    
    [Authorize]
    [HttpGet]
    public async Task<ActionResult> List()
    {
        var userId = User.FindFirst("idUsuario")!.Value;
        var transactionListResult = await _iTransactionService.ListByUser(userId);
        if(transactionListResult.IsFailure)
            return StatusCode(500, transactionListResult.ErrorMenssage);
        var response = _iMapper.Map<List<TransactionResponse>>(transactionListResult.Data);
        return Ok(response);
    }

    [Authorize]
    [HttpGet("{id}")]
    public async Task<ActionResult> GetById(int id)
    {
        var transactionResult = await _iTransactionService.GetEntityById(id);
        if(transactionResult.IsFailure)
            return StatusCode(500, transactionResult.ErrorMenssage);
        if (transactionResult.NotFound)
            return NotFound();
        var response = _iMapper.Map<TransactionResponse>(transactionResult.Data);
        return Ok(response);
    }
    [Authorize]
    [HttpPut]
    public async Task<ActionResult> Update(TransactionRequest request)
    {
        var transaction = _iMapper.Map<Transaction>(request);
        var savedTransactionResult = await _iTransactionService.GetEntityById(transaction.Id);
        if(savedTransactionResult.IsFailure)
            return StatusCode(500, savedTransactionResult.ErrorMenssage);
        if (savedTransactionResult.NotFound)
            return NotFound();
        var updatedTransactionResult = await _iTransactionService.Update(transaction);
        if(updatedTransactionResult.IsFailure)
            return StatusCode(500, updatedTransactionResult.ErrorMenssage);
        var response = _iMapper.Map<TransactionResponse>(updatedTransactionResult.Data);
        return Ok(response);
    }
    [Authorize]
    [HttpDelete("{id}")]
    public async Task<ActionResult> Delete(int id)
    {
        var transactionResult = await _iTransactionService.GetEntityById(id);
        if(transactionResult.IsFailure)
            return StatusCode(500, transactionResult.ErrorMenssage);
        if (transactionResult.NotFound)
            return NotFound();
        var deleteResult = await _iTransactionService.Delete(transactionResult.Data!);
        if(deleteResult.IsFailure)
            return StatusCode(500, transactionResult.ErrorMenssage);
        return NoContent();
    }
}