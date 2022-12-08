using System.IdentityModel.Tokens.Jwt;

namespace WeBudgetWebAPI.Configurations;

public class TokenJwt
{
    private readonly JwtSecurityToken _token;
    internal  TokenJwt(JwtSecurityToken token)
    {
        this._token = token;
    }

    public DateTime ValidTo => _token.ValidTo;

    public string value => new JwtSecurityTokenHandler().WriteToken(this._token);
}