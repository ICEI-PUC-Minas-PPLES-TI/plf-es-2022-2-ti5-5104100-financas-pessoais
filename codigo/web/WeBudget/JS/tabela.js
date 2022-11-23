
fetch('https://webudgetpuc.azurewebsites.net/api/transaction',{
    headers: {
        'Authorization': `Bearer ${retornarTokenUsuario()}`
    }}).then(data => data.json())
    .then(data => {
        data.forEach(transation => {
            pokeTable(transation.description,
              transation.categoryId,
                transation.paymentValue,
                transation.tansactionType)
    })
    fetch('https://webudgetpuc.azurewebsites.net/api/category', {
        headers: {
          'Authorization': `Bearer ${retornarTokenUsuario()}`
        }
      }).then((e) => e.json())
        .then((e) => {
          e.forEach(result => {
            // console.log(result.id)
  
            label=0
if(result.id==data.categoryId){
    label.push(result.description)
    console.log(label)
}
        })})

})


    function pokeTable(description, categoryId, paymentValue, tansactionType) {
        let pTable = document.getElementById('poketable');
        let tRow = document.createElement('tr');

        console.log("description:"+description, ", categoryId"+categoryId, ", paymentValue"+paymentValue, ", tansactionType"+tansactionType)
        if(tansactionType == 0){
          tansactionType = "Receita"
        }else if(tansactionType == 1){
          tansactionType = "Despesa"
        }

        fetch('https://webudgetpuc.azurewebsites.net/api/category', {
          headers: {
            'Authorization': `Bearer ${retornarTokenUsuario()}`
          }
        }).then((e) => e.json())
          .then((e) => {
            
            e.forEach(element => {
              if(element.id == categoryId){
                  categoryId =  element.description
                  console.log(element)
              }
              tRow.innerHTML = `
            <td>${description}</td>
            <td>${categoryId}</td>
            <td>${paymentValue}</td>
            <td>${tansactionType}</td>
        `;
        pTable.appendChild(tRow);
            });
          })



        
    }


