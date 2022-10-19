using System.ComponentModel.DataAnnotations;
using WeBudgetWebAPI.Models.Enums;

namespace WeBudgetWebAPI.DTOs;

public class TransactionRequest
{
    public int Id { get; set; }
    [Required(ErrorMessage = "O campo {0} é obrigatório")]
    public string Description { get; set; }
    [Required(ErrorMessage = "O campo {0} é obrigatório")]
    public double PaymentValue { get; set; }
    [Required(ErrorMessage = "O campo {0} é obrigatório")]
    public string PaymentType { get; set; }
    [Required(ErrorMessage = "O campo {0} é obrigatório")]
    public TansactionType  TansactionType{ get; set; }
    [Required(ErrorMessage = "O campo {0} é obrigatório")]
    public DateTime TansactionDate{ get; set; }
    [Required(ErrorMessage = "O campo {0} é obrigatório")]
    public double Latitude { get; set; }
    [Required(ErrorMessage = "O campo {0} é obrigatório")]
    public double Longitude { get; set; }
    [Required(ErrorMessage = "O campo {0} é obrigatório")]
    public string Address { get; set; }
    [Required(ErrorMessage = "O campo {0} é obrigatório")]
    public int CategoryId { get; set; }
}