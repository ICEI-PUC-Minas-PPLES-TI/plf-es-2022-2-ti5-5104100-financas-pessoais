const realizarLogin = (event) => {
    event.preventDefault();
  
    const renamedData = {
      email: document.querySelector('#email').value,
      senha: document.querySelector('#senha').value,
    }
  
    const xhr = new XMLHttpRequest();
  
    xhr.open('POST', '', true);
    xhr.setRequestHeader("Content-type", "application/json");
  
    xhr.onreadystatechange = () => {
      if (xhr.readyState == 4) {
        if (xhr.status == 200) {
          let tokenUsuario = JSON.parse(xhr.responseText);
          if (tokenUsuario) {
            localStorage.setItem('userToken', JSON.stringify(tokenUsuario.data));
            window.location.href = 'modulos.html';
          }
        }
        else {
          console.log(xhr.responseText);
        }
      }
    }
  
    xhr.send(JSON.stringify(renamedData));
  }