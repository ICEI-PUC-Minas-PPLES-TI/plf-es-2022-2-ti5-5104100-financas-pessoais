fetch('https://webudgetpuc.azurewebsites.net/api/transaction',{
    headers: {
        'Authorization': `Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJXZUJ1ZGdldCIsImp0aSI6IjBjMzExOTczLTVkNTAtNGU5OS04MzMzLTIzNGRmNzhhNWM3NCIsImlkVXN1YXJpbyI6IjI0MzE5MWExLTQ4NmMtNGNkMy1hNzFkLTM3NDUwYzA5NDNmMyIsImV4cCI6MTY2OTIxMjI5MiwiaXNzIjoiVGVzdGUuU2VjdXJpcnkuQmVhcmVyIiwiYXVkIjoiVGVzdGUuU2VjdXJpcnkuQmVhcmVyIn0.i6QmWftDPDV5QZ1Vdp_ghyB1QwO-hBD27xvgotyk-40`
    }}).then(data => data.json())
    .then(data => {
        var year=[]
        var soma=0
        data.forEach(element => {
            if(year.includes(new Date(element.tansactionDate).getFullYear())){

            }else{
                year.push(new Date(element.tansactionDate).getFullYear())
            }
            console.log(year)
            year.forEach((result)=>{
                if(element.tansactionType==0){
                 soma+=element.paymentValue
                    }  
            })
           console.log(soma)
        });


         //Gráfico de linhas receitas por ano
receitasAno = document.getElementById("receitasAno");


new Chart(receitasAno,  {
    type: 'line',
    data: {
        labels: year,
                    
        datasets: [
            {
                label: 'Receitas',
                data: [soma],
                backgroundColor: "#9DFF89",
                borderColor: "#2CAF1E"
            }
        ]
    }
});



    })





   //despesas

   fetch('https://webudgetpuc.azurewebsites.net/api/transaction',{
    headers: {
        'Authorization': `Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJXZUJ1ZGdldCIsImp0aSI6IjBjMzExOTczLTVkNTAtNGU5OS04MzMzLTIzNGRmNzhhNWM3NCIsImlkVXN1YXJpbyI6IjI0MzE5MWExLTQ4NmMtNGNkMy1hNzFkLTM3NDUwYzA5NDNmMyIsImV4cCI6MTY2OTIxMjI5MiwiaXNzIjoiVGVzdGUuU2VjdXJpcnkuQmVhcmVyIiwiYXVkIjoiVGVzdGUuU2VjdXJpcnkuQmVhcmVyIn0.i6QmWftDPDV5QZ1Vdp_ghyB1QwO-hBD27xvgotyk-40`
    }}).then(data => data.json())
    .then(data => {
        var year=[]
        var soma=0
        data.forEach(element => {
            if(year.includes(new Date(element.tansactionDate).getFullYear())){

            }else{
                year.push(new Date(element.tansactionDate).getFullYear())
            }
            console.log(year)
            year.forEach((result)=>{
                if(element.tansactionType==1){
                 soma+=element.paymentValue
                    }  
            })
           console.log(soma)
        });
        let primeiroGrafico = document.getElementById("despesasAno");

let chart = new Chart(primeiroGrafico, {
    type:'bar',
    data: {
        labels: year,
        datasets: [{
            label:'Despesas',
          data: [soma],
          backgroundColor: [
            '#9DFF89',
            '#9DFF89',
            '#9DFF89',
            '#9DFF89',
            '#9DFF89',
            '#9DFF89'
          ],
          borderColor: [
            '#2CAF1E',
          ],
          borderWidth: 3
        }],
options:{
        legend:{
            display:false
        },
    }
    }
});
});