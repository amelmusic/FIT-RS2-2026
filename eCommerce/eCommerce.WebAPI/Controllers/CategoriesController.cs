using eCommerce.Services;
using eCommerce.Model.Requests;
using eCommerce.Model.Responses;
using eCommerce.Model.SearchObjects;

namespace eCommerce.WebAPI.Controllers;

public class CategoriesController : BaseCRUDController<CategoryResponse, CategorySearch, CategoriesInsertRequest, CategoriesUpdateRequest, ICategoryService>
{
    public CategoriesController(ICategoryService categoryService) : base(categoryService)
    {
    }
}