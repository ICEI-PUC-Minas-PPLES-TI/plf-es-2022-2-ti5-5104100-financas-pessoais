namespace WeBudgetWebAPI.DTOs;

public class CategoryReponse
{
    public int Id { get; set; }

    public string Description { get; set; }

    public int IconCode { get; set; }

    public CategoryReponse(int id, string description, int iconCode)
    {
        Id=id;
        Description=description;
        IconCode=iconCode;
    }
}