using System.Text.Json.Serialization;

namespace WeBudgetWebAPI.DTOs.Response;

public class UsuarioLoginResponse
{
    public bool Sucesso  => Erros.Count == 0;
        
    [JsonIgnore(Condition = JsonIgnoreCondition.WhenWritingNull)]
    public string AccessToken { get; private set; }

    [JsonIgnore(Condition = JsonIgnoreCondition.WhenWritingNull)]
    public int? ExpiresIn { get; private set; }
    
    [JsonIgnore(Condition = JsonIgnoreCondition.WhenWritingNull)]
    public string UserId { get; private set; }
    
    [JsonIgnore(Condition = JsonIgnoreCondition.WhenWritingNull)]
    public string FirstName { get; private set; }
    
    [JsonIgnore(Condition = JsonIgnoreCondition.WhenWritingNull)]
    public string LastName { get; private set; }
        
    public List<string> Erros { get; private set; }

    public UsuarioLoginResponse()=>Erros = new List<string>();
    public UsuarioLoginResponse(bool sucesso, string accessToken, int expiresIn, string userId, string lastName, string firstName) : this()
    {
        AccessToken = accessToken;
        ExpiresIn = expiresIn;
        UserId = userId;
        FirstName = firstName;
        LastName = lastName;
    }

    public void AdicionarErro(string erro) =>
        Erros.Add(erro);

    public void AdicionarErros(IEnumerable<string> erros) =>
        Erros.AddRange(erros);
}