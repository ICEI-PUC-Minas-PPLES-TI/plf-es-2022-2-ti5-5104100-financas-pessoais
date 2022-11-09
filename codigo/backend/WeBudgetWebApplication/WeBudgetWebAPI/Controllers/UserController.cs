using System.Text;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.WebUtilities;
using WeBudgetWebAPI.Configurations;
using WeBudgetWebAPI.DTOs;
using WeBudgetWebAPI.Interfaces.Sevices;

namespace WeBudgetWebAPI.Controllers;

[ApiController]
[Route("api/[controller]")]
public class UserController:ControllerBase
{
    // private IIdentityService _identityService;
    //
    // public UserController(IIdentityService identityService) =>
    //     _identityService = identityService;
    //
    // [HttpPost("cadastro")]
    // public async Task<ActionResult<UsuarioCadastroResponse>> Cadastrar(UsuarioCadastroRequest usuarioCadastro)
    // {
    //     if (!ModelState.IsValid)
    //         return BadRequest();
    //
    //     var resultado = await _identityService.CadastrarUsuario(usuarioCadastro);
    //     if (resultado.Sucesso)
    //         return Ok(resultado);
    //     else if (resultado.Erros.Count > 0)
    //         return BadRequest(resultado);
    //     
    //     return StatusCode(StatusCodes.Status500InternalServerError);
    // }
    //
    // [HttpPost("login")]
    // public async Task<ActionResult<UsuarioCadastroResponse>> Login(UsuarioLoginRequest usuarioLogin)
    // {
    //     if (!ModelState.IsValid)
    //         return BadRequest();
    //
    //     var resultado = await _identityService.Login(usuarioLogin);
    //     if (resultado.Sucesso)
    //         return Ok(resultado);
    //     
    //     return Unauthorized(resultado);
    // }
    
    private readonly UserManager<IdentityUser> _userManager;
        private readonly SignInManager<IdentityUser> _signInManager;
        public UserController(UserManager<IdentityUser> userManager,
            SignInManager<IdentityUser> signInManager)
        {
            _userManager = userManager;
            _signInManager = signInManager;
        }


        [AllowAnonymous]
        [HttpPost("logar")]
        public async Task<IActionResult> CriarTokenIdentity([FromBody] UsuarioLoginRequest login)
        {
            if (string.IsNullOrWhiteSpace(login.Email) || string.IsNullOrWhiteSpace(login.Senha))
            {
                return Unauthorized();
            }

            var resultado = await
                _signInManager.PasswordSignInAsync(login.Email, login.Senha, false, lockoutOnFailure: false);

            if (resultado.Succeeded)
            {
                // Recupera Usuário Logado
                var userCurrent = await _userManager.FindByEmailAsync(login.Email);
                var idUsuario = userCurrent.Id;

                var token = new TokenJWTBuilder()
                    .AddSecurityKey(JwtSecurityKey.Create("Secret_Key-12345678"))
                .AddSubject("WeBudget")
                .AddIssuer("Teste.Securiry.Bearer")
                .AddAudience("Teste.Securiry.Bearer")
                .AddClaim("idUsuario", idUsuario)
                .AddExpiry(3600)
                .Builder();

                return Ok(token.value);
            }
            else
            {
                return Unauthorized();
            }


        }


        [AllowAnonymous]
        [HttpPost("cadastrar")]
        public async Task<IActionResult> AdicionaUsuario([FromBody] UsuarioCadastroRequest login)
        {
            if (string.IsNullOrWhiteSpace(login.Email) || string.IsNullOrWhiteSpace(login.Senha))
                return Ok("Falta alguns dados");


            var user = new IdentityUser
            {
                UserName = login.Email,
                Email = login.Email,
            };

            var resultado = await _userManager.CreateAsync(user, login.Senha);

            if (resultado.Errors.Any())
            {
                return Ok(resultado.Errors);
            }


            // Geração de Confirmação caso precise
            var userId = await _userManager.GetUserIdAsync(user);
            var code = await _userManager.GenerateEmailConfirmationTokenAsync(user);
            code = WebEncoders.Base64UrlEncode(Encoding.UTF8.GetBytes(code));

            // retorno email 
            code = Encoding.UTF8.GetString(WebEncoders.Base64UrlDecode(code));
            var resultado2 = await _userManager.ConfirmEmailAsync(user, code);

            if (resultado2.Succeeded)
                return Ok("Usuário Adicionado com Sucesso");
            else
                return Ok("Erro ao confirmar usuários");

        }
}