using System.Collections.Generic;
using System.Threading.Tasks;

namespace eCommerce.Services
{
    public interface IBaseReadService<TResponse, TSearch>
        where TSearch : class
    {
        Task<TResponse> GetByIdAsync(int id);
        Task<IList<TResponse>> GetAllAsync(TSearch? search = null);
    }
}
