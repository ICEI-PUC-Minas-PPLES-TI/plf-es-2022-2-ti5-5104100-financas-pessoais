google.charts.load('current', { 'packages': ['corechart'] });

var valoresGrafico = getValoresTrasacoes();
function  getValoresTrasacoes() {
  let url = `https://webudgetpuc.azurewebsites.net/api/Transaction`;
  let request = new XMLHttpRequest();
  request.open('GET', url, false);
  request.setRequestHeader('Authorization', `Bearer ${retornarTokenUsuario()}`);
  request.send();
  const dados = request.responseText;
  var retornoTrasaction = JSON.parse(dados);
  return retornoTrasaction
}
getValoresTrasacoes()

function desenharBarraDespesas() {

  let transacoes = getValoresTrasacoes();
  console.log(transacoes)
  let valorTotalJaneiro = 0;
  let valorTotalFevereiro = 0;
  let valorTotalMarço = 0;
  let valorTotalAbril = 0;
  let valorTotalMaio = 0;
  let valorTotalJunho = 0;
  let valorTotalJulho = 0;
  let valorTotalAgosto = 0;
  let valorTotalSetembro = 0;
  let valorTotalOutubro = 0;
  let valorTotalNovembro = 0;
  let valorTotalDezembro = 0;
  
  let mes = 0;
  for (i = 0; i < transacoes.length; i++) {
    if(transacoes[i].tansactionType==1){
      console.log(transacoes)
      mes = (new Date(transacoes[i].tansactionDate).getMonth());
console.log(mes)
    
      if(mes == '0'){
          valorTotalJaneiro += transacoes[i].paymentValue;
      }     
      
      if(mes == '1'){
          valorTotalFevereiro += transacoes[i].paymentValue;
      }

      if(mes == '2'){
          valorTotalMarço += transacoes[i].paymentValue;
      }

      if(mes == '3'){
          valorTotalAbril += transacoes[i].paymentValue;
      }

      if(mes == '4'){
          valorTotalMaio += transacoes[i].paymentValue;
      }

      if(mes == '5'){
          valorTotalJunho += transacoes[i].paymentValue;
      }

      if(mes == '6'){
          valorTotalJulho += transacoes[i].paymentValue;
      }

      if(mes == '7'){
          valorTotalAgosto += transacoes[i].paymentValue;
      }

      if(mes == '8'){
          valorTotalSetembro += transacoes[i].paymentValue;
      }

      if(mes == '9'){
          valorTotalOutubro += transacoes[i].paymentValue;
      }

      if(mes == '10'){
          valorTotalNovembro += transacoes[i].paymentValue;
      }

      if(mes == '11'){
          valorTotalDezembro += transacoes[i].paymentValue;
      }
    }
}

  


let tabela = new google.visualization.DataTable();
tabela.addColumn('string', 'Mês');
tabela.addColumn('number', 'Valor receitas');
tabela.addRows([

]);


tabela.addRows([
  ['Janeiro', valorTotalJaneiro]
])    

tabela.addRows([
  ['Fevereiro', valorTotalFevereiro]
])

tabela.addRows([
  ['Março', valorTotalMarço]
])

tabela.addRows([
  ['Abril', valorTotalAbril]
])

tabela.addRows([
  ['Maio', valorTotalMaio]
])

tabela.addRows([
  ['Junho', valorTotalJunho]
])

tabela.addRows([
  ['Julho', valorTotalJulho]
])

tabela.addRows([
  ['Agosto', valorTotalAgosto]
])

tabela.addRows([
  ['Setembro', valorTotalSetembro]
])

tabela.addRows([
  ['Outubro', valorTotalOutubro]
])

tabela.addRows([
  ['Novembro', valorTotalNovembro]
])

tabela.addRows([
  ['Dezembro', valorTotalDezembro]
])

let opcoes = {
  'height': 300,
  'width':500,
};


let grafico = new google.visualization.ColumnChart(document.getElementById('graficoGastos_div'));
grafico.draw(tabela, opcoes)
}
google.charts.setOnLoadCallback(desenharBarraDespesas);



// Receitas



google.charts.load('current', { 'packages': ['corechart'] });

var valoresGrafico = getValoresTrasacoes();
function  getValoresTrasacoes() {
  let url = `https://webudgetpuc.azurewebsites.net/api/Transaction`;
  let request = new XMLHttpRequest();
  request.open('GET', url, false);
  request.setRequestHeader('Authorization', `Bearer ${retornarTokenUsuario()}`);
  request.send();
  const dados = request.responseText;
  var retornoTrasaction = JSON.parse(dados);
  return retornoTrasaction
}
getValoresTrasacoes()


function desenharLinhaReceitas() {

      
  let transacoes = getValoresTrasacoes();
  console.log(transacoes)
  let valorTotalJaneiro = 0;
  let valorTotalFevereiro = 0;
  let valorTotalMarço = 0;
  let valorTotalAbril = 0;
  let valorTotalMaio = 0;
  let valorTotalJunho = 0;
  let valorTotalJulho = 0;
  let valorTotalAgosto = 0;
  let valorTotalSetembro = 0;
  let valorTotalOutubro = 0;
  let valorTotalNovembro = 0;
  let valorTotalDezembro = 0;
  
  let mes = 0;
  for (i = 0; i < transacoes.length; i++) {
    if(transacoes[i].tansactionType==0){
      console.log(transacoes)
      mes = (new Date(transacoes[i].tansactionDate).getMonth());
console.log(mes)
    
      if(mes == '0'){
          valorTotalJaneiro += transacoes[i].paymentValue;
      }     
      
      if(mes == '1'){
          valorTotalFevereiro += transacoes[i].paymentValue;
      }

      if(mes == '2'){
          valorTotalMarço += transacoes[i].paymentValue;
      }

      if(mes == '3'){
          valorTotalAbril += transacoes[i].paymentValue;
      }

      if(mes == '4'){
          valorTotalMaio += transacoes[i].paymentValue;
      }

      if(mes == '5'){
          valorTotalJunho += transacoes[i].paymentValue;
      }

      if(mes == '6'){
          valorTotalJulho += transacoes[i].paymentValue;
      }

      if(mes == '7'){
          valorTotalAgosto += transacoes[i].paymentValue;
      }

      if(mes == '8'){
          valorTotalSetembro += transacoes[i].paymentValue;
      }

      if(mes == '9'){
          valorTotalOutubro += transacoes[i].paymentValue;
      }

      if(mes == '10'){
          valorTotalNovembro += transacoes[i].paymentValue;
      }

      if(mes == '11'){
          valorTotalDezembro += transacoes[i].paymentValue;
      }
  }
  
  }

let tabela = new google.visualization.DataTable();
tabela.addColumn('string', 'Mês');
tabela.addColumn('number', 'Valor receitas');
tabela.addRows([

]);


tabela.addRows([
  ['Janeiro', valorTotalJaneiro]
])    

tabela.addRows([
  ['Fevereiro', valorTotalFevereiro]
])

tabela.addRows([
  ['Março', valorTotalMarço]
])

tabela.addRows([
  ['Abril', valorTotalAbril]
])

tabela.addRows([
  ['Maio', valorTotalMaio]
])

tabela.addRows([
  ['Junho', valorTotalJunho]
])

tabela.addRows([
  ['Julho', valorTotalJulho]
])

tabela.addRows([
  ['Agosto', valorTotalAgosto]
])

tabela.addRows([
  ['Setembro', valorTotalSetembro]
])

tabela.addRows([
  ['Outubro', valorTotalOutubro]
])

tabela.addRows([
  ['Novembro', valorTotalNovembro]
])

tabela.addRows([
  ['Dezembro', valorTotalDezembro]
])

let opcoes = {
  'height': 300,
  'width':500,
};


let grafico =  new google.visualization.LineChart(document.getElementById('graficoReceitas_div'));
grafico.draw(tabela, opcoes)
}
google.charts.setOnLoadCallback(desenharLinhaReceitas);



