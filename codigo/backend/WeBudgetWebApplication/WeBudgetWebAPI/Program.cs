using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using WeBudgetWebAPI.Data;
using WeBudgetWebAPI.Interfaces.Sevices;
using WeBudgetWebAPI.Services;
using WeBudgetWebAPI.Extencao;
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
builder.Services.AddScoped<IIdentityService,IdentityServer>();

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