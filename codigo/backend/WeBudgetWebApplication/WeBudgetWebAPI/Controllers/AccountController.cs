using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using WeBudgetWebAPI.DTOs;
using WeBudgetWebAPI.Interfaces;
using WeBudgetWebAPI.Interfaces.Sevices;

namespace WeBudgetWebAPI.Controllers;


[ApiController]
[Route("api/[controller]")]
public class AccountController: ControllerBase
{
    private readonly IAccountService _accountService;
    public AccountController(IAccountService accountService)
    {
        _accountService = accountService;
    }

    [Authorize]
    [HttpGet]
    public async Task<ActionResult> List()
    {
        var userId = User.FindFirst("idUsuario")?.Value;
        if (userId != null)
        {
            var accountList = await _accountService.ListByUser(userId);
            if (accountList.Count == 0)
                return NotFound("Contas não encontrada");
            return Ok(accountList);
        }

        return Problem("Um problema com o token em encontrar o usuario id ");
    }

    [Authorize]
    [HttpGet("{id}")]
    public async Task<ActionResult> GetById(int id)
    {
        var account = await _accountService.GetEntityById(id);
        if(account==null)
            return NotFound("Conta não encontrado");
        return Ok(account);
    }
}