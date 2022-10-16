using System.ComponentModel.DataAnnotations;
using System.Diagnostics.CodeAnalysis;

namespace WeBudgetWebAPI.DTOs;

public class BudgetRequest
{
    public int Id { get; set; }
    [Required(ErrorMessage = "O campo {0} é obrigatório")]
    public double BudgetValue { get; set; }
    [Required(ErrorMessage = "O campo {0} é obrigatório")]
    public DateTime BudgetDate{ get; set; }
    [Required(ErrorMessage = "O campo {0} é obrigatório")]
    public bool Active{ get; set; }
    [Required(ErrorMessage = "O campo {0} é obrigatório")]
    public int CategoryId { get; set; }
    [Required(ErrorMessage = "O campo {0} é obrigatório")]
    public string UserId { get; set; }
}