namespace WeBudgetWebAPI.DTOs;

public class MenssageResponse<T> where T:class
{
    public string Table { get; set; }

    public string Operation { get; set; }
    
    public string UserId { get; set; }

    public T Object { get; set; }
}