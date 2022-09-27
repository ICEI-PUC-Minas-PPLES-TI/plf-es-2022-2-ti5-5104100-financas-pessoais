namespace WeBudgetWebAPI.DTOs;

public class UsuarioCadastroResponse
{
    public bool Sucesso { get; set; }
    public List<string> Erros { get; set; }

    public UsuarioCadastroResponse() =>
        Erros = new List<string>();

    public UsuarioCadastroResponse(bool sucesso = true):this() =>
        Sucesso = sucesso;

    public void AdicionarErros(IEnumerable<string> erros) =>
        Erros.AddRange(erros);
}