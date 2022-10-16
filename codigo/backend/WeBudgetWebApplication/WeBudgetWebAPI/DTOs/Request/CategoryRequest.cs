using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace WeBudgetWebAPI.DTOs;

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