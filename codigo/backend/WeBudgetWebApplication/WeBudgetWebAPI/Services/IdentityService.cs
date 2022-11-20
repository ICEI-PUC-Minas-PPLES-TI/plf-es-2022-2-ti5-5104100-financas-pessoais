using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Options;
using WeBudgetWebAPI.Configurations;
using WeBudgetWebAPI.DTOs.Request;
using WeBudgetWebAPI.DTOs.Response;
using WeBudgetWebAPI.Interfaces.Sevices;
using WeBudgetWebAPI.Models;

namespace WeBudgetWebAPI.Services;

public class IdentityService:IIdentityService
{

    private readonly SignInManager<IdentityUser> _signInManager;
    private readonly UserManager<IdentityUser> _userManager;
    private readonly IMailService _mailService;

    public IdentityService(SignInManager<IdentityUser> signInManager,
        UserManager<IdentityUser> userManager, IOptions<JwtOptions> jwOptions,
        IMailService mailService)
    {
        _signInManager = signInManager;
        _userManager = userManager;
        _mailService = mailService;
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

    public async Task<Result> ForgotPassword(ForgotPasswordRequest forgotPassword)
    {
        var user = _userManager.FindByEmailAsync(forgotPassword.Email);
        if (user == null)
            return Result.Fail("Usuário não encontrado");
        var token = await _userManager.GeneratePasswordResetTokenAsync(await user);
        if (token == null)
            return Result.Fail("Problemas para gerar o token");
        //Url de recuperacao
        var resetUrl = "token= " + token;
        MailRequest request = new MailRequest()
        {
            ToEmail = forgotPassword.Email,
            Subject = "Recuperação de Senha",
            Body = resetUrl
        } ;
        try
        {
            await _mailService.SendEmailAsync(request);
            return Result.Ok();
        }
        catch (Exception e)
        {
            return Result.Fail(e.Message);
        }
    }

    public async Task<Result> ResetPassword(ResetPasswordRequest resetPassword)
    {
        var user = _userManager.FindByEmailAsync(resetPassword.Email);
        if (user == null)
            return Result.Fail("Usuário não encontrado");
        var result = await _userManager.ResetPasswordAsync(await user,
            resetPassword.Token, resetPassword.Password);
        if (!result.Succeeded)
            return Result.Fail(string.Join("; ",
                result.Errors.Select(x=>x.Description)));
        
        return Result.Ok();
    }
}