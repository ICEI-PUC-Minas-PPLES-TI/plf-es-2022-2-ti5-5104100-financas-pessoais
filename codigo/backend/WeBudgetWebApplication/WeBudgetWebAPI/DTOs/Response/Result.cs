namespace WeBudgetWebAPI.DTOs;

public class Result<T> where T : class
{
    public bool Success { get; }
    public string? Menssage { get; }
    public string? StackTrace { get;  }
    public T? Resource { get;  }
    
    
    public Result() 
        => Success = true;
    
    public Result(string menssage)
    {
        Success = false;
        Menssage = menssage;
    }

    public Result(string stackTrace,string menssage) : this( menssage)
        => StackTrace = stackTrace;


    private Result(T resource) : this()
        => Resource = resource;
    
}