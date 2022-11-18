using WeBudgetWebAPI.Models.Enums;
using OperationType = Microsoft.OpenApi.Models.OperationType;

namespace WeBudgetWebAPI.DTOs;

public class MenssageResponse<T> where T:class
{
    public TableType Table { get; set; }

    public Models.Enums.OperationType Operation { get; set; }
    
    public string UserId { get; set; }

    public T Object { get; set; }
}