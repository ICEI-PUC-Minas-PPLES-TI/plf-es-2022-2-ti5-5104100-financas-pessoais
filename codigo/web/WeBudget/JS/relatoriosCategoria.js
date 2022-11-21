
//receita
var arrSoma = []
fetch('https://webudgetpuc.azurewebsites.net/api/category', {
  headers: {
    'Authorization': `Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJXZUJ1ZGdldCIsImp0aSI6IjBjMzExOTczLTVkNTAtNGU5OS04MzMzLTIzNGRmNzhhNWM3NCIsImlkVXN1YXJpbyI6IjI0MzE5MWExLTQ4NmMtNGNkMy1hNzFkLTM3NDUwYzA5NDNmMyIsImV4cCI6MTY2OTIxMjI5MiwiaXNzIjoiVGVzdGUuU2VjdXJpcnkuQmVhcmVyIiwiYXVkIjoiVGVzdGUuU2VjdXJpcnkuQmVhcmVyIn0.i6QmWftDPDV5QZ1Vdp_ghyB1QwO-hBD27xvgotyk-40`

  }
})
  .then(data => data.json())
  .then(data => {
    // console.log(data)
    data.forEach(element => {
    // console.log(element)
      fetch('https://webudgetpuc.azurewebsites.net/api/Transaction', {
        headers: {
          'Authorization': `Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJXZUJ1ZGdldCIsImp0aSI6IjBjMzExOTczLTVkNTAtNGU5OS04MzMzLTIzNGRmNzhhNWM3NCIsImlkVXN1YXJpbyI6IjI0MzE5MWExLTQ4NmMtNGNkMy1hNzFkLTM3NDUwYzA5NDNmMyIsImV4cCI6MTY2OTIxMjI5MiwiaXNzIjoiVGVzdGUuU2VjdXJpcnkuQmVhcmVyIiwiYXVkIjoiVGVzdGUuU2VjdXJpcnkuQmVhcmVyIn0.i6QmWftDPDV5QZ1Vdp_ghyB1QwO-hBD27xvgotyk-40`
        }
      }).then((e) => e.json())
        .then((e) => {
         
          var soma = 0;
          e.forEach(result => {
//  console.log(result.paymentValue)
            if (element.id == result.categoryId && result.tansactionType == 0) {
              soma += result.paymentValue;


              var label = [];
              label.push(element.description)
              window.sessionStorage.setItem("label", label)
              console.log(label)

              arrSoma.push(soma)
              window.sessionStorage.setItem("arrSoma", arrSoma)
              console.log(arrSoma)
            }
          })
          
        })







    });
  })

//grafico rosca das receitas por categoria

plots = document.getElementById("receitasCategoria");

new Chart(plots, {
  type: 'doughnut',
  data: {
    labels: [window.sessionStorage.getItem("label")],
    datasets: [{
      label: 'My First Dataset',
      data: [parseInt(window.sessionStorage.getItem("arrSoma"))],
      backgroundColor: [
        'rgb(255, 99, 132)',
        'rgb(54, 162, 235)',
        'rgb(255, 205, 86)'
      ],
      hoverOffset: 4
    }]
  }
});





//despesas

var arrSoma = []
fetch('https://webudgetpuc.azurewebsites.net/api/category', {
  headers: {
    'Authorization': `Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJXZUJ1ZGdldCIsImp0aSI6IjBjMzExOTczLTVkNTAtNGU5OS04MzMzLTIzNGRmNzhhNWM3NCIsImlkVXN1YXJpbyI6IjI0MzE5MWExLTQ4NmMtNGNkMy1hNzFkLTM3NDUwYzA5NDNmMyIsImV4cCI6MTY2OTIxMjI5MiwiaXNzIjoiVGVzdGUuU2VjdXJpcnkuQmVhcmVyIiwiYXVkIjoiVGVzdGUuU2VjdXJpcnkuQmVhcmVyIn0.i6QmWftDPDV5QZ1Vdp_ghyB1QwO-hBD27xvgotyk-40`

  }
})
  .then(data => data.json())
  .then(data => {
    // console.log(data)
    data.forEach(element => {
     //console.log(element)
      fetch('https://webudgetpuc.azurewebsites.net/api/Transaction', {
        headers: {
          'Authorization': `Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJXZUJ1ZGdldCIsImp0aSI6IjBjMzExOTczLTVkNTAtNGU5OS04MzMzLTIzNGRmNzhhNWM3NCIsImlkVXN1YXJpbyI6IjI0MzE5MWExLTQ4NmMtNGNkMy1hNzFkLTM3NDUwYzA5NDNmMyIsImV4cCI6MTY2OTIxMjI5MiwiaXNzIjoiVGVzdGUuU2VjdXJpcnkuQmVhcmVyIiwiYXVkIjoiVGVzdGUuU2VjdXJpcnkuQmVhcmVyIn0.i6QmWftDPDV5QZ1Vdp_ghyB1QwO-hBD27xvgotyk-40`
        }
      }).then((e) => e.json())
        .then((e) => {
         
          var soma = 0;
          e.forEach(result => {
//  console.log(result.paymentValue)
            if (element.id == result.categoryId && result.tansactionType == 1) {
              soma += result.paymentValue;


              var label = [];
              label.push(element.description)
              window.sessionStorage.setItem("label", label)

              arrSoma.push(soma)
              window.sessionStorage.setItem("arrSoma", arrSoma)
             // console.log(arrSoma)
            }
          })
          
        })







    });
  })

//grafico de rosca das despesas por categoria

plots2 = document.getElementById("gastosCategoria");


new Chart(plots2, {
  type: 'doughnut',
  data: {
    labels: [window.sessionStorage.getItem("label")],
    datasets: [{
      label: 'My First Dataset',
      data: [parseInt(window.sessionStorage.getItem("arrSoma"))],
      backgroundColor: [
        'rgb(255, 99, 132)',
        'rgb(54, 162, 235)',
        'rgb(255, 205, 86)'
      ],
      hoverOffset: 4
    }]
  }
});



