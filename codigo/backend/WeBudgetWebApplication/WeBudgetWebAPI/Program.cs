using AutoMapper;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using WeBudgetWebAPI.Data;
using WeBudgetWebAPI.DTOs;
using WeBudgetWebAPI.Interfaces.Sevices;
using WeBudgetWebAPI.Services;
using WeBudgetWebAPI.Extencao;
using WeBudgetWebAPI.Interfaces;
using WeBudgetWebAPI.Interfaces.Generics;
using WeBudgetWebAPI.Models;
using WeBudgetWebAPI.Repository;
using WeBudgetWebAPI.Repository.Generics;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
//Set o contexto e DB do app
builder.Services.AddDbContext<IdentityDataContext>(options =>
{
    options.UseNpgsql(builder.Configuration.GetConnectionString("Default"));
});

//Identity configuracao
builder.Services.AddAuthentication(builder.Configuration);
builder.Services.AddDefaultIdentity<IdentityUser>()
    .AddRoles<IdentityRole>()
    .AddEntityFrameworkStores<IdentityDataContext>()
    .AddDefaultTokenProviders();
//Escopo
builder.Services.AddSingleton(typeof(IGeneric<>), typeof(RepositoryGenerics<>));
builder.Services.AddScoped<IIdentityService,IdentityServer>();
builder.Services.AddSingleton<ICategory, RepositoryCategory>();
builder.Services.AddSingleton<IBudget, RepositoryBudget>();
builder.Services.AddSingleton<ITransaction, RepositoryTransaction>();
builder.Services.AddSingleton<ITransactionService, TransactionService>();

//AutoMapper
var config = new AutoMapper.MapperConfiguration(cfg =>
{
    //request
    cfg.CreateMap<CategoryRequest, Category>();
    cfg.CreateMap<BudgetRequest, Budget>();
    cfg.CreateMap<TransactionRequest, Transaction>();
    //response
    cfg.CreateMap<Category, CategoryReponse>();
    cfg.CreateMap<Budget, BudgetResponse>();
    cfg.CreateMap<Transaction, TransactionResponse>();
});
IMapper mapper = config.CreateMapper();
builder.Services.AddSingleton(mapper);
var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();