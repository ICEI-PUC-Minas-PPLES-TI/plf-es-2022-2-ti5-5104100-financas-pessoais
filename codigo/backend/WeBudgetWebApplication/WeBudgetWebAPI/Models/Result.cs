namespace WeBudgetWebAPI.Models;

public class Result
{
    public bool Success { get; }
    public bool IsFailure => !Success;
    public string? ErrorMenssage { get; }

    protected Result() => Success = true;
    protected Result(bool success) => Success = success;

    protected Result(string errorMenssage) : this(false)
        => ErrorMenssage = errorMenssage;

    public static Result Ok() => new Result();
    public static Result<T> Ok<T>(T value) => new Result<T>(value);
    public static Result Fail(string errorMenssage) => new Result(errorMenssage);
    public static Result<T> Fail<T>(string errorMenssage) => new Result<T>(errorMenssage);
}

public class Result<T> : Result
{
    public T? Data { get; }

    protected internal Result(T data) : base() 
        => Data = data;
    protected internal Result(string errorMenssage) : base(errorMenssage) 
        => Data = default;
}
