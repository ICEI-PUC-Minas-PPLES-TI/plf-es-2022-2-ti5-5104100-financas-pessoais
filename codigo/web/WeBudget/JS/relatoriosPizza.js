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
  var ListaCategorias = new Array;
  var ListaValorDespesas = new Array;
  console.log(transacoes)
  for (i = 0; i < transacoes.length; i++) {
    if(transacoes[i].tansactionType==1    ){

    ListaCategorias.push(transacoes[i].categoryDescription);
    ListaValorDespesas.push(transacoes[i].paymentValue);
    }
  
}

let tabela = new google.visualization.DataTable();
tabela.addColumn('string', 'Ano');
tabela.addColumn('number', 'Valor despesas');
tabela.addRows([

]);


for (i = 0; i <transacoes.length; i++) {
  tabela.addRows([
      [ListaCategorias[i], ListaValorDespesas[i]]
  ]) 
 
} 
  
let opcoes = {
  'height': 400,
  'width':500,
  pieHole: 0.4,
};


let grafico = new google.visualization.PieChart(document.getElementById('graficoGastos_div'));
grafico.draw(tabela, opcoes)
}
google.charts.setOnLoadCallback(desenharBarraDespesas);





//receitas



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

function desenharRoscaReceitas() {

  let transacoes = getValoresTrasacoes();
  var ListaCategorias = new Array;
  var ListaValorReceitas = new Array;
  console.log(transacoes)
  for (i = 0; i < transacoes.length; i++) {
    if(transacoes[i].tansactionType==0    ){
    ListaCategorias.push(transacoes[i].categoryDescription);
    ListaValorReceitas.push(transacoes[i].paymentValue);
    }
  
}

let tabela = new google.visualization.DataTable();
tabela.addColumn('string', 'Categoria');
tabela.addColumn('number', 'Valor receitas');
tabela.addRows([

]);


for (i = 0; i <transacoes.length; i++) {
  tabela.addRows([
      [ListaCategorias[i], ListaValorReceitas[i]]
  ]) 
 
}


  
let opcoes = {
  'height': 400,
  'width':500,
  pieHole: 0.4,
};


let grafico = new google.visualization.PieChart(document.getElementById('graficoReceitas_div'));
grafico.draw(tabela, opcoes)
}
google.charts.setOnLoadCallback(desenharRoscaReceitas);