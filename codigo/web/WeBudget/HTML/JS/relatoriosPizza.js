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
  var categorias=[];
  var index=0
  console.log(typeof categorias)
  for (i = 0; i < transacoes.length; i++) {
    var existe = Boolean (false)
    if(transacoes[i].tansactionType==1){

      console.log(categorias.includes(transacoes[i].categoryDescription))
      if(categorias.length==0 || categorias.includes(transacoes[i].categoryDescription)==false){
        categorias.push(transacoes[i].categoryDescription)
        console.log(categorias)
      }else{
        for (j = 0; j < categorias.length; j++){
          if(transacoes[i].categoryDescription == categorias[j]){
         console.log("teste")
          }
        }
      }
    
      }
    }
    console.log(categorias) 
var payment= [];
var index=0;
categorias.forEach(element=>{
  payment[index]=0;
  index++;
})
index=0

categorias.forEach(element => {
 transacoes.forEach(data =>{
 if(data.categoryDescription==element && data.tansactionType==1){
  payment[index]+=data.paymentValue;
  console.log(data.paymentValue);
 }
 })
 index++;
});
console.log(payment)

let tabela = new google.visualization.DataTable();
tabela.addColumn('string', 'Categoria');
tabela.addColumn('number', 'Valor despesas');
tabela.addRows([

]);


for (i = 0; i <transacoes.length; i++) {
  tabela.addRows([
      [categorias[i], payment[i]]
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
  var categorias2=[];
  console.log(typeof categorias2)
  for (i = 0; i < transacoes.length; i++) {
    var existe = Boolean (false)
    if(transacoes[i].tansactionType==0){
      if(categorias2.length==0 || categorias2.includes(transacoes[i].categoryDescription)==false){
        categorias2.push(transacoes[i].categoryDescription)
      }else{
        for (j = 0; j < categorias2.length; j++){
          if(transacoes[i].categoryDescription == categorias2[j]){
          }
        }
      }
    
      }
    }
    console.log(categorias2) 
var payment2= [];
var index2=0;
categorias2.forEach(element=>{
  payment2[index2]=0;
  index2++;
})
index2=0

categorias2.forEach(element => {
 transacoes.forEach(data =>{
 if(data.categoryDescription==element && data.tansactionType==0){
  payment2[index2]+=data.paymentValue;
  console.log(data.paymentValue);
 }
 })
 index2++;
});
console.log(payment2)


let tabela = new google.visualization.DataTable();
tabela.addColumn('string', 'Categoria');
tabela.addColumn('number', 'Valor receitas');
tabela.addRows([

]);


for (i = 0; i <transacoes.length; i++) {
  tabela.addRows([
      [categorias2[i], payment2[i]]
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