using System.ComponentModel.DataAnnotations;

namespace WeBudgetWebAPI.DTOs.Request;

public class NameUpdateRequest
{
    [Required(ErrorMessage = "O campo {0} é obrigatório")]
    public string FirstName { get; set; }
    [Required(ErrorMessage = "O campo {0} é obrigatório")]
    public string LastName { get; set; }
    [Required(ErrorMessage = "O campo {0} é obrigatório")]
    [EmailAddress]
    public string Email { get; set; }
}