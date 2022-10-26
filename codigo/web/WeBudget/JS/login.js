function realizarLogin(event){
  var url="http://localhost:5001/api/User/login";
  var data={
    "email": document.querySelector("#email").value,
    "senha": document.querySelector("#senha").value

  }
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
      window.location.href="/codigo/web/WeBudget/HTML/index.html"
    }else{
      alert("email ou senha inválidos");
    }
  }).catch((e) =>console.log(e));

  }

console.log(document.querySelector("#email").value);


//document.querySelector("#botaoEntrar").addEventListener("click",()=>{})