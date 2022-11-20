using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using WeBudgetWebAPI.DTOs.Request;
using WeBudgetWebAPI.DTOs.Response;
using WeBudgetWebAPI.Interfaces.Sevices;

namespace WeBudgetWebAPI.Controllers;

[ApiController]
[Route("api/[controller]")]
public class UserController:ControllerBase
{
    private IIdentityService _identityService;
    
    public UserController(IIdentityService identityService) =>
        _identityService = identityService;
    
    [AllowAnonymous]
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
    
    [AllowAnonymous]
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

    [AllowAnonymous]
    [HttpPost("recoveryEmail")]
    public async Task<ActionResult> ForgotPassword(ForgotPasswordRequest forgotPassword)
    {
        if (!ModelState.IsValid)
            return BadRequest();
        
        var result = await _identityService.ForgotPassword(forgotPassword);
        if (result.IsFailure)
            return BadRequest(result.ErrorMenssage);
        return Ok();
    }
    
    [AllowAnonymous]
    [HttpPost("resetPassword")]
    public async Task<ActionResult> ResetPassword(ResetPasswordRequest resetPassword)
    {
        if (!ModelState.IsValid)
            return BadRequest();
        var result = await _identityService.ResetPassword(resetPassword);
        if (result.IsFailure)
            return BadRequest(result.ErrorMenssage);
        return Ok();
    }
}