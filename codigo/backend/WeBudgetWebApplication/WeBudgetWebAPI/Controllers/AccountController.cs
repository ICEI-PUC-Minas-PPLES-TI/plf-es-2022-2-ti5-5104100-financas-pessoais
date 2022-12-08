using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
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
        var userId = User.FindFirst("idUsuario")!.Value;
        var accountListResult = await _accountService.ListByUser(userId);
        return accountListResult.IsFailure ? 
            StatusCode(500, accountListResult.ErrorMenssage) : Ok(accountListResult.Data);
    }

    [Authorize]
    [HttpGet("{id}")]
    public async Task<ActionResult> GetById(int id)
    {
        var accountResult = await _accountService.GetEntityById(id);
        if (accountResult.IsFailure)
            return StatusCode(500, accountResult.ErrorMenssage);
        if (accountResult.NotFound)
            return NotFound();
        return Ok(accountResult.Data);
    }
}