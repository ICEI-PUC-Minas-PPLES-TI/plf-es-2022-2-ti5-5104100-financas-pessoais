namespace WeBudgetWebAPI.Models
{
    public class Resposta<T>where T : class

    {
        public string Tabela;

        public string TipoOperacao;

        public T Object;

        public Resposta(string tabela, string tipoOperacao, T @object)
        {
            Tabela=tabela;
            TipoOperacao=tipoOperacao;
            Object=@object;
        }
    }
}
