
function realizarLogin(event){
  var url="https://webudgetpuc.azurewebsites.net/api/User/login";
  var data={
    "email": document.querySelector("#email").value,
    "senha": document.querySelector("#senha").value

  }
  console.log(data);
  fetch(url,{
    method:"POST",
    headers:{
      "Content-Type":"application/json"
    },
    body:
    JSON.stringify(data)
  })
  .then((response) => response.json())
  .then((data) => {
    console.log(data.sucesso)
    if(data.sucesso){
          console.log(data.accessToken)
          localStorage.setItem('userToken', JSON.stringify(data.accessToken));
       //   window.location.href = 'modulos.html';
    
      console.log(data);
      console.log(retornarTokenUsuario())
      window.location.href="/codigo/web/WeBudget/HTML/tabela.html"
    }else{
      alert("email ou senha inválidos");
    }
  }).catch((e) =>console.log(e));

  }

console.log(document.querySelector("#email").value);
