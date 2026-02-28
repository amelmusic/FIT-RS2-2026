using System;
using System.Collections.Generic;
using System.Linq;
using eCommerce.Model.Requests;
using eCommerce.Model.Responses;
using eCommerce.Model.SearchObjects;
using eCommerce.Services.Database;

namespace eCommerce.Services
{
    public class CategoryService : BaseCRUDService<Category, CategoryResponse, CategorySearch, CategoriesInsertRequest, CategoriesUpdateRequest>, ICategoryService
    {
        // dummy in-memory collection with some hierarchical categories
        private static readonly List<Category> _dummyCategories = new()
        {
            new Category
            {
                Id = 1,
                Name = "Electronics",
                Description = "Electronic devices and gadgets.",
                IsActive = true,
                CreatedAt = DateTime.UtcNow.AddDays(-30)
            },
            new Category
            {
                Id = 2,
                Name = "Computers",
                Description = "Desktops, laptops and accessories.",
                ParentCategoryId = 1,
                IsActive = true,
                CreatedAt = DateTime.UtcNow.AddDays(-28)
            },
            new Category
            {
                Id = 3,
                Name = "Smartphones",
                Description = "Mobile phones and accessories.",
                ParentCategoryId = 1,
                IsActive = true,
                CreatedAt = DateTime.UtcNow.AddDays(-25)
            },
            new Category
            {
                Id = 4,
                Name = "Home",
                Description = "Home and kitchen products.",
                IsActive = true,
                CreatedAt = DateTime.UtcNow.AddDays(-20)
            }
        };

        public CategoryService(MapsterMapper.IMapper mapper) : base(mapper)
        {
        }

        protected override IEnumerable<Category> GetDataSource()
        {
            return _dummyCategories;
        }

        protected override IList<Category> GetWritableDataSource()
        {
            return _dummyCategories;
        }

        protected override IEnumerable<Category> ApplyFilters(IEnumerable<Category> query, CategorySearch? search)
        {
            if (search != null)
            {
                if (!string.IsNullOrWhiteSpace(search.Name))
                {
                    query = query.Where(c => c.Name.Contains(search.Name, StringComparison.OrdinalIgnoreCase));
                }

                if (search.ParentCategoryId.HasValue)
                {
                    query = query.Where(c => c.ParentCategoryId == search.ParentCategoryId.Value);
                }
            }

            return query;
        }
    }
}