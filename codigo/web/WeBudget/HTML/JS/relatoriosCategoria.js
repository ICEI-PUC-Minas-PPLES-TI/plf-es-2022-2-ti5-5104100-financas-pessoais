google.charts.load('current', { 'packages': ['corechart'] });

var categorias = getCategorias();
function getCategorias() {
  let url = `https://webudgetpuc.azurewebsites.net/api/category`;
  let request = new XMLHttpRequest();
  request.open('GET', url, false);
  request.setRequestHeader('Authorization', `Bearer ${retornarTokenUsuario()}`);
  request.send();
  const dados = request.responseText;
  var retorno = JSON.parse(dados);
  var listaCategorias = [];

  retorno.forEach(element => {
    listaCategorias.push(element.id)
  });


  return listaCategorias;
}
console.log(categorias);


var valoresGrafico = getValoresTrasacoes();
function getValoresTrasacoes() {
  let url = `https://webudgetpuc.azurewebsites.net/api/Transaction`;
  let request = new XMLHttpRequest();
  request.open('GET', url, false);
  request.setRequestHeader('Authorization', `Bearer ${retornarTokenUsuario()}`);
  request.send();
  const dados = request.responseText;
  var retornoTrasaction = JSON.parse(dados);
  var valoresDespesa = 0;
  var valoresReceita = 0;

  retornoTrasaction.forEach(element => {
    if (element.tansactionType == 1) {
      valoresDespesa += element.paymentValue;
    } else {
      valoresReceita += element.paymentValue
    }
  });

  var arrayValores = []
  arrayValores.push(valoresReceita.toString());
  arrayValores.push(valoresDespesa.toString())

  return arrayValores;
}



var transacoes = getTransactions();
function getTransactions() {
  let url = `https://webudgetpuc.azurewebsites.net/api/Transaction`;
  let request = new XMLHttpRequest();
  request.open('GET', url, false);
  request.setRequestHeader('Authorization', `Bearer ${retornarTokenUsuario()}`);
  request.send();
  const dados = request.responseText;
  var retornoTrasaction = JSON.parse(dados);


  return retornoTrasaction;
}
console.log(transacoes);



/**
 * Construção do gráfico
 */
var categorias = []
categorias.push("Receita");
categorias.push("Despesa")

var receita = valoresGrafico[0];
var despesa = valoresGrafico[1];

plots = document.getElementById("receitasCategoria");

new Chart(plots, {
  type: 'doughnut',
  data: {
    labels: ["Receita", "Despesa"],
    datasets: [{
      label: 'My First Dataset',
      data: [receita, despesa],
      backgroundColor: [
        'rgb(255, 99, 132)',
        'rgb(54, 162, 235)',
        'rgb(255, 205, 86)'
      ],
      hoverOffset: 4
    }]
  }
});



// //Gráfico de barra - quantidade de Transacoes feitos
function desenharBarraTransacoes() {

  let valorTotalCredito = 0;
  let valorTotalDebito = 0;
  let valorTotalCheque = 0;
  let valorTotalPix = 0;
  let valorTotalDinheiro = 0;


  var tiposTrasacao = ["Crédito", "Débito", "Cheque", "Pix", "Dinheiro"]

  for (let i = 0; i < transacoes.length; i++) {

    if (transacoes[i].tansactionType == 1) {

      if (transacoes[i].paymentType == tiposTrasacao[0]) {
        valorTotalCredito += parseInt(transacoes[i].paymentValue);
      }

      if (transacoes[i].paymentType == tiposTrasacao[1]) {
        valorTotalDebito += parseInt(transacoes[i].paymentValue);
      }

      if (transacoes[i].paymentType == tiposTrasacao[2]) {
        valorTotalCheque += parseInt(transacoes[i].paymentValue);
      }

      if (transacoes[i].paymentType == tiposTrasacao[3]) {
        valorTotalPix += parseInt(transacoes[i].paymentValue);
      }

      if (transacoes[i].paymentType == tiposTrasacao[4]) {
        valorTotalDinheiro += parseInt(transacoes[i].paymentValue);
      }
    }
  }

  console.log(valorTotalCredito);
  console.log(valorTotalDebito);
  console.log(valorTotalCheque);
  console.log(valorTotalPix);
  console.log(valorTotalDinheiro);


  let tabela = new google.visualization.DataTable();
  tabela.addColumn('string', 'Categorias');
  tabela.addColumn('number', 'Valores');
  tabela.addRows([

  ]);

  tabela.addRows([
    [tiposTrasacao[0], valorTotalCredito]
  ])

  tabela.addRows([
    [tiposTrasacao[1], valorTotalDebito]
  ])

  tabela.addRows([
    [tiposTrasacao[2], valorTotalCheque]
  ])

  tabela.addRows([
    [tiposTrasacao[3], valorTotalPix]
  ])

  tabela.addRows([
    [tiposTrasacao[4], valorTotalDinheiro]
  ])


  let opcoes = {
    'height': 500,
    'width': 1200,
  };

  let grafico = new google.visualization.ColumnChart(document.getElementById('gastosCategoria'));
  grafico.draw(tabela, opcoes)

}
google.charts.setOnLoadCallback(desenharBarraTransacoes);