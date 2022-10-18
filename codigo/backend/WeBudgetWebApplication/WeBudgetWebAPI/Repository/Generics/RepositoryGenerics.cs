using System.Runtime.InteropServices;
using Microsoft.EntityFrameworkCore;
using Microsoft.Win32.SafeHandles;
using WeBudgetWebAPI.Data;
using WeBudgetWebAPI.Interfaces.Generics;


namespace WeBudgetWebAPI.Repository.Generics;

public class RepositoryGenerics<T> : IGeneric<T>, IDisposable where T : class
    {
        private readonly DbContextOptions<IdentityDataContext> _OptionsBuilder;

        public RepositoryGenerics()
        {
            _OptionsBuilder = new DbContextOptions<IdentityDataContext>();
        }

        public async Task<T> Add(T Objeto)
        {
            using (var data = new IdentityDataContext(_OptionsBuilder))
            {
                var entityEntry = await data.Set<T>().AddAsync(Objeto);
                await data.SaveChangesAsync();
                return entityEntry.Entity;
            }
        }

        public async Task Delete(T Objeto)
        {
            using (var data = new IdentityDataContext(_OptionsBuilder))
            {
                data.Set<T>().Remove(Objeto);
                await data.SaveChangesAsync();
            }
        }

        public async Task<T> GetEntityById(int Id)
        {
            using (var data = new IdentityDataContext(_OptionsBuilder))
            {
                return await data.Set<T>().FindAsync(Id);
            }
        }

        public async Task<List<T>> List()
        {
            using (var data = new IdentityDataContext(_OptionsBuilder))
            {
                return await data.Set<T>().ToListAsync();
            }
        }

        public async Task<T> Update(T Objeto)
        {
            using (var data = new IdentityDataContext(_OptionsBuilder))
            {
                var entityEntry = data.Set<T>().Update(Objeto); 
                await data.SaveChangesAsync();
                return entityEntry.Entity;

            }
        }

        #region Disposed https://docs.microsoft.com/pt-br/dotnet/standard/garbage-collection/implementing-dispose
        // Flag: Has Dispose already been called?
        bool disposed = false;
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
            if (disposed)
                return;

            if (disposing)
            {
                handle.Dispose();
                // Free any other managed objects here.
                //
            }

            disposed = true;
        }
        #endregion


    }