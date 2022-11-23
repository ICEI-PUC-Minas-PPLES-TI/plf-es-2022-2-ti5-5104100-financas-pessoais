  
  function retornarTokenUsuario() {
    let userToken = JSON.parse(localStorage.getItem('userToken'));
    return userToken;
  }