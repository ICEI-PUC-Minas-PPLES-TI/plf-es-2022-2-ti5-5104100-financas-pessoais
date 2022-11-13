using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using WeBudgetWebAPI.DTOs;
using WeBudgetWebAPI.Interfaces;

namespace WeBudgetWebAPI.Controllers;


[ApiController]
[Route("api/[controller]")]
public class AccountController: ControllerBase
{
    private readonly IAccount _iAccount;

    public AccountController(IAccount iAccount)
    {
        _iAccount = iAccount;
    }
    [Authorize]
    [HttpGet]
    public async Task<ActionResult> List()
    {
        //var userId = User.FindFirst(JwtRegisteredClaimNames.Sub).Value;
        var userId = User.FindFirst("idUsuario").Value;
        var accountList = await _iAccount.ListByUser(userId);
        if (accountList.Count == 0)
            return NotFound("Contas não encontrada");
        return Ok(accountList);
    }

    [Authorize]
    [HttpGet("{id}")]
    public async Task<ActionResult> GetById(int id)
    {
        var conta = await _iAccount.GetEntityById(id);
        if(conta==null)
            return NotFound("Conta não encontrado");
        return Ok(conta);
    }
}