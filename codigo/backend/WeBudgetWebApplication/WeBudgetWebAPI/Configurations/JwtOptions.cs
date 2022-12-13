using Microsoft.IdentityModel.Tokens;

namespace WeBudgetWebAPI.Configurations;

public abstract class JwtOptions
{
    public string? Issuer { get; set; }
    public string? Audience { get; set; }
    public SigningCredentials? SigningCredentials { get; set; }
    public int AccessTokenExpiration { get; set; }
    public int RefreshTokenExpiration { get; set; }
}