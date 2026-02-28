using Scalar.AspNetCore;
using eCommerce.Services;
using Mapster;
using eCommerce.Services.Database;
using eCommerce.Model.Responses;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();

// register Mapster for object mapping
builder.Services.AddMapster();

// configure a few mappings explicitly if needed (optional)
// Mapster will automatically map same-named properties, but configuration
// ensures any custom rules or future needs can be added here.
TypeAdapterConfig<Product, ProductResponse>.NewConfig();
TypeAdapterConfig<Category, CategoryResponse>.NewConfig();

// register application services
builder.Services.AddScoped<IProductService, ProductService>();
// category service
builder.Services.AddScoped<ICategoryService, CategoryService>();

// Learn more about configuring OpenAPI at https://aka.ms/aspnet/openapi
builder.Services.AddOpenApi();

var app = builder.Build();

// Configure the HTTP request pipeline.
//if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
    app.MapScalarApiReference();
}

//app.UseHttpsRedirection();

//app.UseAuthorization();

app.MapControllers();

app.Run();
