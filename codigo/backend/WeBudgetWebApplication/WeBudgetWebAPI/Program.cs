using AutoMapper;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using WeBudgetWebAPI.Configurations;
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
//builder.Services.AddAuthentication(builder.Configuration);
// builder.Services.AddDefaultIdentity<IdentityUser>()
//     .AddRoles<IdentityRole>()
//     .AddEntityFrameworkStores<IdentityDataContext>()
//     .AddDefaultTokenProviders();
builder.Services.AddDefaultIdentity<IdentityUser>(options => options.SignIn.RequireConfirmedAccount = true)
    .AddEntityFrameworkStores<IdentityDataContext>();

// JWT
builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(option =>
    {
        option.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = false,
            ValidateAudience = false,
            ValidateLifetime = true,
            ValidateIssuerSigningKey = true,

            ValidIssuer = "Teste.Securiry.Bearer",
            ValidAudience = "Teste.Securiry.Bearer",
            IssuerSigningKey = JwtSecurityKey.Create("Secret_Key-12345678")
        };

        option.Events = new JwtBearerEvents
        {
            OnAuthenticationFailed = context =>
            {
                Console.WriteLine("OnAuthenticationFailed: " + context.Exception.Message);
                return Task.CompletedTask;
            },
            OnTokenValidated = context =>
            {
                Console.WriteLine("OnTokenValidated: " + context.SecurityToken);
                return Task.CompletedTask;
            }
        };
    });

//Escopo
builder.Services.AddSingleton(typeof(IGeneric<>),
    typeof(RepositoryGenerics<>));
builder.Services.AddSingleton(typeof(IMessageBrokerService<>),
    typeof(MenssageBrokerService<>));
builder.Services.AddScoped<IIdentityService,IdentityServer>();
builder.Services.AddSingleton<ICategory, RepositoryCategory>();
builder.Services.AddSingleton<IBudget, RepositoryBudget>();
builder.Services.AddSingleton<ITransaction, RepositoryTransaction>();
builder.Services.AddSingleton<IAccount, RepositoryAccount>();
builder.Services.AddSingleton<IBudgetService, BudgetService>();
builder.Services.AddSingleton<IAccountService, AccountService>();
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

app.UseAuthentication();
app.UseRouting();
app.UseAuthorization();
app.UseCors(x => x
    .AllowAnyOrigin()
    .AllowAnyMethod()
    .AllowAnyHeader());
app.MapControllers();
app.Run();