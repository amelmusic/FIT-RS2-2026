using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace eCommerce.Services
{
    public abstract class BaseReadService<TEntity, TResponse, TSearch> : IBaseReadService<TResponse, TSearch>
        where TEntity : class
        where TSearch : class
    {
        protected readonly MapsterMapper.IMapper _mapper;

        protected BaseReadService(MapsterMapper.IMapper mapper)
        {
            _mapper = mapper;
        }

        /// <summary>
        /// Gets the in-memory data source for this entity type.
        /// </summary>
        protected abstract IEnumerable<TEntity> GetDataSource();

        /// <summary>
        /// Applies search filters to the query. Override in derived classes to implement specific filtering logic.
        /// </summary>
        protected abstract IEnumerable<TEntity> ApplyFilters(IEnumerable<TEntity> query, TSearch? search);

        public async Task<IList<TResponse>> GetAllAsync(TSearch? search = null)
        {
            IEnumerable<TEntity> query = GetDataSource();
            query = ApplyFilters(query, search);

            var responses = query.Select(item => _mapper.Map<TResponse>(item)).ToList();
            return await Task.FromResult<IList<TResponse>>(responses);
        }

        public async Task<TResponse> GetByIdAsync(int id)
        {
            var entity = GetDataSource().FirstOrDefault(e => (int)e.GetType().GetProperty("Id")?.GetValue(e)! == id);
            if (entity == null)
            {
                throw new KeyNotFoundException($"{typeof(TEntity).Name} with id {id} not found.");
            }

            return await Task.FromResult(_mapper.Map<TResponse>(entity));
        }
    }
}
