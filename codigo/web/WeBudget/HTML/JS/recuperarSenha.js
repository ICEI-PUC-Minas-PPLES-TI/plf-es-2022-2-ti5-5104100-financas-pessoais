
const saveProvider = (data) => {
    console.log("Data", data)
    const renamedData = {
      email: data.email,
    }
    console.log("passou",renamedData);
    const xhr = new XMLHttpRequest();
  
    xhr.open('POST', 'https://webudgetpuc.azurewebsites.net/api/User/recoveryEmail');
    xhr.setRequestHeader("Content-type", "application/json");
    xhr.send(JSON.stringify(renamedData));
    xhr.onreadystatechange = () => {
      if (xhr.readyState == 4) {
        if (xhr.status == 200) {
          alert('Email enviado', 'success')
          setTimeout(() => {window.location.href="Login.html"}, 2000);
          throw new Error("Email enviado")
        }
        else {
          alert('Email não enviado', 'danger')
          setTimeout(() => {window.location.href="Login.html"}, 2000);
          throw new Error("Error")
        }
      }
    }
  }
  
  const formRecovery = {
    getValue() {
      return {
        email: document.querySelector('#email').value,
      }
    },
  
    validateFields() {
      const { email } = formRecovery.getValue()
      if (email.trim() === "") {
        throw new Error("Por favor, preencha todos o email")
      }
    },
  
    formatProvider() {
      let { email } = formRecovery.getValue()
      return {
        email
      }
    },
  
    clearProvider() {
      formRecovery.email.value = ""
    },
  
    submit(event) {
      console.log("passou");
      event.preventDefault()
      try {
        formRecovery.validateFields()
        const SaveProvider = formRecovery.formatProvider()
        saveProvider(SaveProvider)
      } catch (error) {
        alert(error.message)
      }
    }
  }