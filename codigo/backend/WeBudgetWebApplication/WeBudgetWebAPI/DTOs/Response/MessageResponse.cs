using Newtonsoft.Json;
using Newtonsoft.Json.Converters;
using WeBudgetWebAPI.Models.Enums;

namespace WeBudgetWebAPI.DTOs.Response;

public class MessageResponse<T> where T:class
{
    [JsonConverter(typeof(StringEnumConverter))]
    public TableType Table { get; set; }
    [JsonConverter(typeof(StringEnumConverter))]
    public OperationType Operation { get; set; }
    public string UserId { get; set; }
    public T Object { get; set; }
}