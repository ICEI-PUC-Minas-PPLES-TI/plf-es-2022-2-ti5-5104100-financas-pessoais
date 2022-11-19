using System.ComponentModel.DataAnnotations;

namespace WeBudgetWebAPI.DTOs.Request;

public class CategoryRequest
{
    public int Id { get; set; }
    [Required(ErrorMessage = "O campo {0} é obrigatório")]
    public string Description { get; set; }
    [Required(ErrorMessage = "O campo {0} é obrigatório")]
    public int IconCode { get; set; }
    [Required(ErrorMessage = "O campo {0} é obrigatório")]
    public string UserId { get; set; }
}