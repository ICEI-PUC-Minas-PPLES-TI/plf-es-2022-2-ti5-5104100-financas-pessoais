using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using Microsoft.IdentityModel.Tokens;

namespace WeBudgetWebAPI.Configurations;

public class TokenJwtBuilder
{
    private SecurityKey _securityKey = null;
        private string _subject = "";
        private string _issuer = "";
        private string _audience = "";
        private readonly Dictionary<string, string> _claims = new Dictionary<string, string>();
        private int _expiryInMinutes = 5;

        public TokenJwtBuilder AddSecurityKey(SecurityKey securityKey)
        {
            this._securityKey = securityKey;
            return this;
        }

        public TokenJwtBuilder AddSubject(string subject)
        {
            this._subject = subject;
            return this;
        }

        public TokenJwtBuilder AddIssuer(string issuer)
        {
            this._issuer = issuer;
            return this;
        }

        public TokenJwtBuilder AddAudience(string audience)
        {
            this._audience = audience;
            return this;
        }

        public TokenJwtBuilder AddClaim(string type, string value)
        {
            this._claims.Add(type, value);
            return this;
        }

        public TokenJwtBuilder AddClaims(Dictionary<string, string> claims)
        {
            this._claims.Union(claims);
            return this;
        }

        public TokenJwtBuilder AddExpiry(int expiryInMinutes)
        {
            this._expiryInMinutes = expiryInMinutes;
            return this;
        }


        private void EnsureArguments()
        {
            if (this._securityKey == null)
                throw new ArgumentNullException("Security Key");

            if (string.IsNullOrEmpty(this._subject))
                throw new ArgumentNullException("Subject");

            if (string.IsNullOrEmpty(this._issuer))
                throw new ArgumentNullException("Issuer");

            if (string.IsNullOrEmpty(this._audience))
                throw new ArgumentNullException("Audience");
        }


        public TokenJwt Builder()
        {
            EnsureArguments();

            var claims = new List<Claim>
            {
                new Claim(JwtRegisteredClaimNames.Sub,this._subject),
                new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString())
            }.Union(this._claims.Select(item => new Claim(item.Key, item.Value)));

            var token = new JwtSecurityToken(
                issuer: this._issuer,
                audience: this._audience,
                claims: claims,
                expires: DateTime.UtcNow.AddMinutes(_expiryInMinutes),
                signingCredentials: new SigningCredentials(
                                                   this._securityKey,
                                                   SecurityAlgorithms.HmacSha256)

                );

            return new TokenJwt(token);

        }
}