using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using WeBudgetWebAPI.DTOs.Request;
using WeBudgetWebAPI.Interfaces.Sevices;
using WeBudgetWebAPI.Models.Entities;
using WeBudgetWebAPI.Services;

namespace TestWeBudgetWebAPI.ServicesTest;

public class IdentityServiceTest
{
    private readonly IdentityService _identityService;
    private readonly Mock<UserManager<ApplicationUser>> _userManagerMock;
    private readonly Mock<SignInManager<ApplicationUser>> _signInManagerMock;

    public IdentityServiceTest()
    {
        var mailServiceMock = new Mock<IMailService>();
        var userMock = new Mock<IUserStore<ApplicationUser>>();
        var mockHttpContextAccessor = new Mock<IHttpContextAccessor>();
        var mockClaimsFactory = new Mock<IUserClaimsPrincipalFactory<ApplicationUser>>();
        _userManagerMock = new Mock<UserManager<ApplicationUser>>(userMock.Object,
            null, null, null, null, null, null, null, null);
        _signInManagerMock = new Mock<SignInManager<ApplicationUser>>(_userManagerMock.Object,
            mockHttpContextAccessor.Object, mockClaimsFactory.Object, null, null, null, null);
        _identityService = new IdentityService(_signInManagerMock.Object,
            _userManagerMock.Object, mailServiceMock.Object);
    }

    [Fact]
    public async Task CadastrarUsuario_ShouldReturnUsuarioCadastroResponse()
    {
        //Arrange
        var signUpUser = new UsuarioCadastroRequest()
        {
            Email = "test@test.com",
            FirstName = "First",
            LastName = "Last",
            Senha = "Password",
            SenhaConfimacao = "Password"
        };
        _userManagerMock.Setup(x =>
            x.CreateAsync(It.IsAny<ApplicationUser>(),It.IsAny<string>() ))
            .ReturnsAsync(IdentityResult.Success);
        //Act
        var user =await _identityService.CadastrarUsuario(signUpUser);
        //Assert
        Assert.True(user.Sucesso);
    }

    [Fact]
    public async Task Login_ShouldReturnUsuarioLoginResponse()
    {
        //Arrange
        var signUpUser = new UsuarioLoginRequest()
        {
            Email = "test@test.com",
            Senha = "Password"
        };
        var appUser = new ApplicationUser()
        {
            Email = "test@test.com",
            Id = "0000-0000-0000",
            FirstName = "First",
            LastName = "Last"
        };
        _signInManagerMock.Setup(x =>
                x.PasswordSignInAsync(It.IsAny<string>(),It.IsAny<string>(),
                    false, false))
            .ReturnsAsync(SignInResult.Success);
        _userManagerMock.Setup(x =>
                x.FindByEmailAsync(It.IsAny<string>()))
            .ReturnsAsync(appUser);
        //Act
        var user =await _identityService.Login(signUpUser);
        //Assert
        Assert.True(user.Sucesso);
    }
    [Fact]
    public async Task ForgotPassword_ShouldReturnResultOk()
    {
        //Arrange
        var forgotPassword = new ForgotPasswordRequest()
        {
            Email = "teste@teste.com"
        };
        var appUser = new ApplicationUser();
        var token = "token";
        _userManagerMock.Setup(x =>
                x.FindByEmailAsync(It.IsAny<string>()))
            .ReturnsAsync(appUser);
        _userManagerMock.Setup(x =>
                x.GeneratePasswordResetTokenAsync(It.IsAny<ApplicationUser>()))
            .ReturnsAsync(token);
        //Act
        var result =await _identityService.ForgotPassword(forgotPassword);
        //Assert
        Assert.True(result.Success);
    }

    [Fact]
    public async Task ResetPassword_ShouldReturnResultOk()
    {
        //Arrange
        var resetPassword = new ResetPasswordRequest()
        {
            Token = "token",
            Password = "123456"
        };
        var appUser = new ApplicationUser();
        _userManagerMock.Setup(x =>
                x.FindByEmailAsync(It.IsAny<string>()))
            .ReturnsAsync(appUser);
        _userManagerMock.Setup(x =>
                x.ResetPasswordAsync(It.IsAny<ApplicationUser>(),It.IsAny<string>(),
                    It.IsAny<string>()))
            .ReturnsAsync(IdentityResult.Success);
        //Act
        var result =await _identityService.ResetPassword(resetPassword);
        //Assert
        Assert.True(result.Success);
    }
    [Fact]
    public async Task ChangeName_ShouldReturnResultOk()
    {
        //Arrange
        var nameUpdate = new NameUpdateRequest()
        {
            FirstName = "First",
            LastName = "Last",
            Email = "test@test.com"
        };
        var appUser = new ApplicationUser()
        {
            Email = "test@test.com",
            Id = "0000-0000-0000",
            FirstName = "First",
            LastName = "Last"
        };
        _userManagerMock.Setup(x =>
                x.FindByEmailAsync(It.IsAny<string>()))
            .ReturnsAsync(appUser);
        _userManagerMock.Setup(x =>
                x.UpdateAsync(It.IsAny<ApplicationUser>()))
            .ReturnsAsync(IdentityResult.Success);
        //Act
        var result =await _identityService.ChangeName(nameUpdate);
        //Assert
        Assert.True(result.Success);
    }
    
}