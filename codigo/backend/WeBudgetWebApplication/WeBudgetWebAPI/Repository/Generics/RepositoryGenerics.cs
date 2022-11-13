using System.Runtime.InteropServices;
using Microsoft.EntityFrameworkCore;
using Microsoft.Win32.SafeHandles;
using WeBudgetWebAPI.Data;
using WeBudgetWebAPI.Interfaces.Generics;


namespace WeBudgetWebAPI.Repository.Generics;

public class RepositoryGenerics<T> : IGeneric<T>, IDisposable where T : class
    {
        private readonly DbContextOptions<IdentityDataContext> _optionsBuilder;

        public RepositoryGenerics()
        {
            _optionsBuilder = new DbContextOptions<IdentityDataContext>();
        }

        public async Task<T> Add(T objeto)
        {
            using (var data = new IdentityDataContext(_optionsBuilder))
            {
                var entityEntry = await data.Set<T>().AddAsync(objeto);
                await data.SaveChangesAsync();
                return entityEntry.Entity;
            }
        }

        public async Task Delete(T objeto)
        {
            using (var data = new IdentityDataContext(_optionsBuilder))
            {
                data.Set<T>().Remove(objeto);
                await data.SaveChangesAsync();
            }
        }

        public async Task<T?> GetEntityById(int id)
        {
            using (var data = new IdentityDataContext(_optionsBuilder))
            {
                return await data.Set<T>().FindAsync(id);
            }
        }

        public async Task<List<T>> List()
        {
            using (var data = new IdentityDataContext(_optionsBuilder))
            {
                return await data.Set<T>().ToListAsync();
            }
        }

        public async Task<T> Update(T objeto)
        {
            using (var data = new IdentityDataContext(_optionsBuilder))
            {
                var entityEntry = data.Set<T>().Update(objeto); 
                await data.SaveChangesAsync();
                return entityEntry.Entity;

            }
        }

        #region Disposed https://docs.microsoft.com/pt-br/dotnet/standard/garbage-collection/implementing-dispose
        // Flag: Has Dispose already been called?
        bool _disposed = false;
        // Instantiate a SafeHandle instance.
        SafeHandle handle = new SafeFileHandle(IntPtr.Zero, true);



        // Public implementation of Dispose pattern callable by consumers.
        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }


        // Protected implementation of Dispose pattern.
        protected virtual void Dispose(bool disposing)
        {
            if (_disposed)
                return;

            if (disposing)
            {
                handle.Dispose();
                // Free any other managed objects here.
                //
            }

            _disposed = true;
        }
        #endregion


    }