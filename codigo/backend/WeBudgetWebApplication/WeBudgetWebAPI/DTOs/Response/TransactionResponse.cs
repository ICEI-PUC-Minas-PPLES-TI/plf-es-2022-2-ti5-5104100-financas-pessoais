using WeBudgetWebAPI.Models.Enums;

namespace WeBudgetWebAPI.DTOs;

public class TransactionResponse
{
    public int Id { get; set; }
    public string Description { get; set; }
    public double PaymentValue { get; set; }
    public string PaymentType { get; set; }
    public TansactionType  TansactionType{ get; set; }
    public DateTime TansactionDate{ get; set; }
    public double Latitude { get; set; }
    public double Longitude { get; set; }
    public string Address { get; set; }
    public int CategoryId { get; set; }
}