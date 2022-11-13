using WeBudgetWebAPI.Models.Enums;

namespace WeBudgetWebAPI.DTOs;

public class MenssageResponse<T> where T:class
{
    public TableType Table { get; set; }

    public OperationType Operation { get; set; }
    
    public string UserId { get; set; }

    public T Object { get; set; }
}