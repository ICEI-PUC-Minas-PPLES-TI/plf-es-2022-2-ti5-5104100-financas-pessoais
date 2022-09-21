using System.Runtime.CompilerServices;
using Microsoft.AspNetCore.Mvc;
using WeBudgetAPI.Models;

namespace WeBudgetAPI.Controllers;

[ApiController]
[Route("api/[controller]")]
public class UserController : ControllerBase
{
    
    [HttpGet]
    public async Task<IActionResult> Get()
    {
        return Ok();
    }

    [HttpPost]
    public async Task<IActionResult> Post(User user)
    {
        return Ok("Usuário adicionado com sucesso");
    }

    [HttpGet("{id}")]
    public async Task<IActionResult> GetById(int id)
    {
        return Ok();
    }

    [HttpPut("{id}")]
    public async Task<IActionResult> Put(int id, User usuario)
    {
        return Ok("Usuário atualizado com sucesso");
    }

    [HttpDelete("{id}")]
    public async Task<IActionResult> Delete(int id)
    {
        return Ok("Usuário deletado com sucesso");
    }
}