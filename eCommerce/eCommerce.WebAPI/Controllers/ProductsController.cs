using eCommerce.Services;
using eCommerce.Model.Responses;
using eCommerce.Model.SearchObjects;

namespace eCommerce.WebAPI.Controllers;

public class ProductsController : BaseReadController<ProductResponse, ProductSearch, IProductService>
{
    public ProductsController(IProductService productService) : base(productService)
    {
    }
}
