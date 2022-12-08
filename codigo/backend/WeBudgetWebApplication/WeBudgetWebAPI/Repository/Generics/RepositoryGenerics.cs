using System.Runtime.InteropServices;
using Microsoft.EntityFrameworkCore;
using Microsoft.Win32.SafeHandles;
using WeBudgetWebAPI.Data;
using WeBudgetWebAPI.Interfaces.Generics;
using WeBudgetWebAPI.Models;
namespace WeBudgetWebAPI.Repository.Generics;

public class RepositoryGenerics<T> : IGeneric<T>, IDisposable where T : class
    {
        private readonly DbContextOptions<IdentityDataContext> _optionsBuilder;

        public RepositoryGenerics()
        {
            _optionsBuilder = new DbContextOptions<IdentityDataContext>();
        }

        public async Task<Result<T>> Add(T add)
        {
            try
            {
                await using (var data = new IdentityDataContext(_optionsBuilder))
                {
                    var entityEntry = await data.Set<T>().AddAsync(add);
                    await data.SaveChangesAsync();
                    return Result.Ok(entityEntry.Entity);
                }
            }
            catch (Exception e)
            {
                return Result.Fail<T>(e.Message);
            }
        }

        public async Task<Result> Delete(T delete)
        {
            try
            {
                await using (var data = new IdentityDataContext(_optionsBuilder))
                {
                    data.Set<T>().Remove(delete);
                    await data.SaveChangesAsync();
                    return Result.Ok();
                }
            }
            catch (Exception e)
            {
                return Result.Fail(e.Message);
            }
            
        }

        public async Task<Result<T>> GetEntityById(int id)
        {
            try
            {
                await using (var data = new IdentityDataContext(_optionsBuilder))
                { 
                    var entity = await data.Set<T>().FindAsync(id);
                    return entity == null ? 
                        Result.NotFound<T>() : Result.Ok(entity);
                }
            }
            catch (Exception e)
            {
                return Result.Fail<T>(e.Message);
            }
            
        }

        public async Task<Result<List<T>>> List()
        {
            try
            {
                await using (var data = new IdentityDataContext(_optionsBuilder))
                {
                    var entityList = await data.Set<T>().ToListAsync();
                    return Result.Ok(entityList);
                }
            }
            catch (Exception e)
            {
                Console.WriteLine(e);
                throw;
            }
            
        }

        public async Task<Result<T>> Update(T update)
        {

            try
            {
                await using (var data = new IdentityDataContext(_optionsBuilder))
                {
                    var entityEntry = data.Set<T>().Update(update); 
                    await data.SaveChangesAsync();
                    return Result.Ok(entityEntry.Entity);

                }
            }
            catch (Exception e)
            {
                return Result.Fail<T>(e.Message);
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