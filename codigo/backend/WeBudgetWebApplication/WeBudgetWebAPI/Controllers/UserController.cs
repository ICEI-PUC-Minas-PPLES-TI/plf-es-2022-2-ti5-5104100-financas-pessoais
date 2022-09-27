using Microsoft.AspNetCore.Mvc;
using WeBudgetWebAPI.DTOs;
using WeBudgetWebAPI.Interfaces.Sevices;

namespace WeBudgetWebAPI.Controllers;

[ApiController]
[Route("api/[controller]")]
public class UserController:ControllerBase
{
    private IIdentityService _identityService;

    public UserController(IIdentityService identityService) =>
        _identityService = identityService;

    [HttpPost("cadastro")]
    public async Task<ActionResult<UsuarioCadastroResponse>> Cadastrar(UsuarioCadastroRequest usuarioCadastro)
    {
        if (!ModelState.IsValid)
            return BadRequest();

        var resultado = await _identityService.CadastrarUsuario(usuarioCadastro);
        if (resultado.Sucesso)
            return Ok(resultado);
        else if (resultado.Erros.Count > 0)
            return BadRequest(resultado);
        
        return StatusCode(StatusCodes.Status500InternalServerError);
    }

    [HttpPost("login")]
    public async Task<ActionResult<UsuarioCadastroResponse>> Login(UsuarioLoginRequest usuarioLogin)
    {
        if (!ModelState.IsValid)
            return BadRequest();

        var resultado = await _identityService.Login(usuarioLogin);
        if (resultado.Sucesso)
            return Ok(resultado);
        
        return Unauthorized(resultado);
    }
}