using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Options;
using WeBudgetWebAPI.Configurations;
using WeBudgetWebAPI.DTOs;
using WeBudgetWebAPI.Interfaces.Sevices;

namespace WeBudgetWebAPI.Services;

public class IdentityService:IIdentityService
{

    private readonly SignInManager<IdentityUser> _signInManager;
    private readonly UserManager<IdentityUser> _userManager;

    public IdentityService(SignInManager<IdentityUser> signInManager,
        UserManager<IdentityUser> userManager, IOptions<JwtOptions> jwOptions)
    {
        _signInManager = signInManager;
        _userManager = userManager;
    }

    public async Task<UsuarioCadastroResponse> CadastrarUsuario(UsuarioCadastroRequest usuarioCadastro)
    {
        var identityUser = new IdentityUser
        {
            UserName = usuarioCadastro.Email,
            Email = usuarioCadastro.Email,
            EmailConfirmed = true
        };

        var result = await _userManager.CreateAsync(identityUser, usuarioCadastro.Senha);
        if (result.Succeeded)
            await _userManager.SetLockoutEnabledAsync(identityUser, false);

        var usuarioCadastroResponse = new UsuarioCadastroResponse(result.Succeeded);
        if (!result.Succeeded && result.Errors.Count() > 0)
            usuarioCadastroResponse.AdicionarErros(result.Errors.Select(r => r.Description));

        return usuarioCadastroResponse;
    }

    public async Task<UsuarioLoginResponse> Login(UsuarioLoginRequest usuarioLogin)
    {
        var result = await
            _signInManager.PasswordSignInAsync(usuarioLogin.Email, usuarioLogin.Senha,
                false, lockoutOnFailure: false);
        var usuarioLoginResponse = new UsuarioLoginResponse();
        if (!result.Succeeded )
            usuarioLoginResponse.AdicionarErro(result.ToString());
        else
        {
            // Recupera Usuário Logado
            var userCurrent = await _userManager.FindByEmailAsync(usuarioLogin.Email);
            var userId = userCurrent.Id;
            var expiresIn = 3600;
            var token = new TokenJWTBuilder()
                .AddSecurityKey(JwtSecurityKey.Create("Secret_Key-12345678"))
                .AddSubject("WeBudget")
                .AddIssuer("Teste.Securiry.Bearer")
                .AddAudience("Teste.Securiry.Bearer")
                .AddClaim("idUsuario", userId)
                .AddExpiry(expiresIn)
                .Builder();
            usuarioLoginResponse = new UsuarioLoginResponse(result.Succeeded, token.value,expiresIn, userId);
        }
        
        return usuarioLoginResponse;
    }
    
    
    
}