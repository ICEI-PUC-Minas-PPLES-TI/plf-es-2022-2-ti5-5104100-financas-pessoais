using System.ComponentModel.DataAnnotations;

namespace WeBudgetWebAPI.DTOs.Request;

public class ForgotPasswordRequest
{
    [Required]
    [EmailAddress]
    public string Email { get; set; }
}