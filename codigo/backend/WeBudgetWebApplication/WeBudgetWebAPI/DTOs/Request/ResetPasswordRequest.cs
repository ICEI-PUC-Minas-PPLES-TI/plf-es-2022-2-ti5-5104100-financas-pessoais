using System.ComponentModel.DataAnnotations;

namespace WeBudgetWebAPI.DTOs.Request;

public class ResetPasswordRequest
{
    public string Token { get; set; }

    public string Email { get; set; }
    [DataType(DataType.Password)]
    public string Password { get; set; }
    [Compare("Password")]
    [DataType(DataType.Password)]
    public string ComfirmPassword { get; set; }
}