import 'dart:math';
import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:we_budget/components/categoria_dropdown.dart';

import 'package:we_budget/components/price_point.dart';
import '../models/transactions.dart';

class LineChartWidget extends StatefulWidget {
  // final List<PricePoint> points;
  final List<TransactionModel> transactions;
  final String periodo;

  const LineChartWidget(this.transactions, {Key? key, required this.periodo})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _LineChartWidgetState();

}

class _LineChartWidgetState extends State<LineChartWidget>{
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.89,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: const Color(0xff37434d),
                strokeWidth: 1,
              );
              },
            drawVerticalLine: true,
            getDrawingVerticalLine: (value) {
              return FlLine(
                color: const Color(0xff37434d),
                strokeWidth: 1,
              );
              },
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: const Color(0xff37434d), width: 1),
          ),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(sideTitles: _transforma(widget.periodo), axisNameWidget: Center(child: Text(
              'Data',
              style: TextStyle(
                fontSize: 17.0,
                fontFamily: 'Poppins',
              ),

            ))),
            topTitles: AxisTitles(sideTitles: null),
            rightTitles: AxisTitles(sideTitles: null),
            leftTitles: AxisTitles(sideTitles: null),
          ),

          lineBarsData: [
            LineChartBarData(
              spots: _pricePoints(widget.transactions,widget.periodo).map((point) => FlSpot(point.x, point.y)).toList(),
              isCurved: true,
              curveSmoothness: 0.3,
              color: Colors.green,
              barWidth: 5,
              // dotData: FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: Colors.green.withOpacity(0.3),
              ),
            ),
          ],
        ),
      ),
    );

  }
}
class PricePoint {
  final double x;
  final double y;

  PricePoint({required this.x, required this.y});
}

List<PricePoint>  _pricePoints(List<TransactionModel> transactions, String periodo) {
  DateTime hoje = DateTime.now();
  transactions.forEach((element) {
    if(element.tipoTransacao==0)
    print(element.data.toString() + '   ' + element.valor.toString());
  });
  switch(periodo){
    case 'Máx':
      int index = 0;
      List<double> numbers = List.filled(5, 0);
      List<int> anos = [2018,2019,2020,2021,2022];
      anos.forEach((ano) {
        transactions.forEach((trns) {
          List<String> campos = trns.data.split('-');
          int ano = int.parse(campos[0]);
          int mes = int.parse(campos[1]);
          int dia = int.parse(campos[2]);
          DateTime data_transact = DateTime(ano,mes,dia);
            if(trns.tipoTransacao == 0 && data_transact.year == anos[index]){
              numbers[index] += trns.valor;
              print('adicionar ' + trns.valor.toString() + ' no ano' + anos[index].toString() );
            }
        });
        index++;
      });
      return numbers.mapIndexed(
              (index, element) => PricePoint(x: index.toDouble(), y: element))
          .toList();
      break;
    case '1M':
      int index = 0;
      List<double> numbers = List.filled(5, 0);
      final formatador = DateFormat('dd-MM');

      final primeiro_dia = hoje.subtract(const Duration(days: 32));
      // final primeiro_dia_f = formatador.format(primeiro_dia);
      int dia_um = primeiro_dia.day;
      int mes_um = primeiro_dia.month;
      int ano_um = primeiro_dia.year;

      final segundo_dia = primeiro_dia.add(const Duration(days: 8));
      // final segundo_dia_f = formatador.format(segundo_dia);
      int dia_dois = segundo_dia.day;
      int mes_dois = segundo_dia.month;
      int ano_dois = segundo_dia.year;

      final terceiro_dia = segundo_dia.add(const Duration(days: 8));
      // final terceiro_dia_f = formatador.format(terceiro_dia);
      int dia_tres = terceiro_dia.day;
      int mes_tres = terceiro_dia.month;
      int ano_tres = terceiro_dia.year;

      final quarto_dia = terceiro_dia.add(const Duration(days: 8));
      // final quarto_dia_f = formatador.format(quarto_dia);
      int dia_quatro = quarto_dia.day;
      int mes_quatro = quarto_dia.month;
      int ano_quatro = quarto_dia.year;

      int dia_atual = hoje.day;
      int mes_atual = hoje.month;
      int ano_atual = hoje.year;
      // final dia_atual_f = formatador.format(hoje);

      // List<String> lista = [primeiro_dia_f,segundo_dia_f,terceiro_dia_f,quarto_dia_f,dia_atual_f];;


      List<int> dias = [dia_um,dia_dois,dia_tres,dia_quatro,dia_atual];
      List<int> meses = [mes_um,mes_dois,mes_tres,mes_quatro,mes_atual];
      List<int> anos = [ano_um,ano_dois,ano_tres,ano_quatro,ano_atual];
      List<int> meses_distintos = [];

      meses.forEach((element) {
        if(!meses_distintos.contains(element)){
          meses_distintos.add(element);
        }
      });

      print(dias);
      print(meses);
      print(meses_distintos);
      List<double> valores = List.filled(5, 0);


        transactions.forEach((transact) {
          int index = 0;
          dias.forEach((dia) {
          List<String> campos = transact.data.split('-');
          int ano = int.parse(campos[0]);
          int mes = int.parse(campos[1]);
          int dia = int.parse(campos[2]);
          DateTime data_transact = DateTime(ano,mes,dia);
          DateTime data_param = DateTime(anos[index],meses[index],dias[index]);
            if(transact.tipoTransacao == 0){
              if(!(index==0)){
                print('oi');
                print(data_param.difference(data_transact).inDays.toString() + (data_param.difference(data_transact).inDays < 8).toString());
                if(data_transact.difference(data_param).inDays < 8 && data_param.month == data_transact.month){
                  print(data_transact.difference(data_param).inDays);
                  print('adicionar ' + transact.valor.toString() + ' no dia' + data_param.toString());
                  valores[index] += transact.valor;
                }

              }else{
                DateTime dia_index = DateTime(anos[index],meses[index],dias[index]);
                if(dia_index.difference(data_transact).inDays < data_transact.day && data_param.month == data_transact.month){
                valores[index] += transact.valor;
                }
              }
            }
            index++;
        });
      });

        int index2 = 0;
        valores.forEach((element) {
          if(index2 > 0){
            if(element == 0.0){
              if(meses[index2] == meses[index2-1]){
                valores[index2] += valores[index2-1];
              }
            }
          }
          index2++;
        });

        print(valores.mapIndexed(
                (index, element) => PricePoint(x: index.toDouble(), y: element))
            .toList().map((point) => FlSpot(point.x, point.y)).toList());

        return valores
            .mapIndexed(
                (index, element) => PricePoint(x: index.toDouble(), y: element))
            .toList();

      break;
    case '3M':
      int index = 0;
      List<double> numbers = List.filled(5, 0);
      final formatador = DateFormat('dd-MM');

      final primeiro_dia = hoje.subtract(const Duration(days: 96));
      // final primeiro_dia_f = formatador.format(primeiro_dia);
      int dia_um = primeiro_dia.day;
      int mes_um = primeiro_dia.month;
      int ano_um = primeiro_dia.year;

      final segundo_dia = primeiro_dia.add(const Duration(days: 24));
      // final segundo_dia_f = formatador.format(segundo_dia);
      int dia_dois = segundo_dia.day;
      int mes_dois = segundo_dia.month;
      int ano_dois = segundo_dia.year;

      final terceiro_dia = segundo_dia.add(const Duration(days: 24));
      // final terceiro_dia_f = formatador.format(terceiro_dia);
      int dia_tres = terceiro_dia.day;
      int mes_tres = terceiro_dia.month;
      int ano_tres = terceiro_dia.year;

      final quarto_dia = terceiro_dia.add(const Duration(days: 24));
      // final quarto_dia_f = formatador.format(quarto_dia);
      int dia_quatro = quarto_dia.day;
      int mes_quatro = quarto_dia.month;
      int ano_quatro = quarto_dia.year;

      int dia_atual = hoje.day;
      int mes_atual = hoje.month;
      int ano_atual = hoje.year;
      // final dia_atual_f = formatador.format(hoje);

      // List<String> lista = [primeiro_dia_f,segundo_dia_f,terceiro_dia_f,quarto_dia_f,dia_atual_f];;


      List<int> dias = [dia_um,dia_dois,dia_tres,dia_quatro,dia_atual];
      List<int> meses = [mes_um,mes_dois,mes_tres,mes_quatro,mes_atual];
      List<int> anos = [ano_um,ano_dois,ano_tres,ano_quatro,ano_atual];
      List<int> meses_distintos = [];

      meses.forEach((element) {
        if(!meses_distintos.contains(element)){
          meses_distintos.add(element);
        }
      });

      print(dias);
      print(meses);
      print(meses_distintos);
      List<double> valores = List.filled(5, 0);


      transactions.forEach((transact) {
        int index = 0;
        dias.forEach((dia) {
          List<String> campos = transact.data.split('-');
          int ano = int.parse(campos[0]);
          int mes = int.parse(campos[1]);
          int dia = int.parse(campos[2]);
          DateTime data_transact = DateTime(ano,mes,dia);
          DateTime data_param = DateTime(anos[index],meses[index],dias[index]);
          if(transact.tipoTransacao == 0){
            if(!(index==0)){
              print(data_transact.difference(data_param).inDays.toString() + (data_param.difference(data_transact).inDays < 24).toString());
              if(data_transact.difference(data_param).inDays < 24 && data_param.month == data_transact.month){
                print(data_transact.difference(data_param).inDays);
                print('adicionar ' + transact.valor.toString() + ' no dia' + data_param.toString());
                valores[index] += transact.valor;
              }

            }else{
              DateTime dia_index = DateTime(anos[index],meses[index],dias[index]);
              if(dia_index.difference(data_transact).inDays < data_transact.day && data_param.month == data_transact.month){
                valores[index] += transact.valor;
                print('adicionar ' + transact.valor.toString() + ' no dia' + data_param.toString());
              }
            }
          }
          index++;
        });
      });
      int index2 = 0;
      valores.forEach((element) {
        if(index2 > 0){
          if(element == 0.0){
            if(meses[index2] == meses[index2-1]){
              valores[index2] += valores[index2-1];
            }
          }
        }
        index2++;
      });

      return valores
          .mapIndexed(
              (index, element) => PricePoint(x: index.toDouble(), y: element))
          .toList();


      break;
    case '6M':
      int index = 0;
      List<double> numbers = List.filled(5, 0);
      final formatador = DateFormat('dd-MM');

      final primeiro_dia = hoje.subtract(const Duration(days: 182));
      // final primeiro_dia_f = formatador.format(primeiro_dia);
      int dia_um = primeiro_dia.day;
      int mes_um = primeiro_dia.month;
      int ano_um = primeiro_dia.year;

      final segundo_dia = primeiro_dia.add(const Duration(days: 48));
      // final segundo_dia_f = formatador.format(segundo_dia);
      int dia_dois = segundo_dia.day;
      int mes_dois = segundo_dia.month;
      int ano_dois = segundo_dia.year;

      final terceiro_dia = segundo_dia.add(const Duration(days: 48));
      // final terceiro_dia_f = formatador.format(terceiro_dia);
      int dia_tres = terceiro_dia.day;
      int mes_tres = terceiro_dia.month;
      int ano_tres = terceiro_dia.year;

      final quarto_dia = terceiro_dia.add(const Duration(days: 48));
      // final quarto_dia_f = formatador.format(quarto_dia);
      int dia_quatro = quarto_dia.day;
      int mes_quatro = quarto_dia.month;
      int ano_quatro = quarto_dia.year;

      int dia_atual = hoje.day;
      int mes_atual = hoje.month;
      int ano_atual = hoje.year;
      // final dia_atual_f = formatador.format(hoje);

      // List<String> lista = [primeiro_dia_f,segundo_dia_f,terceiro_dia_f,quarto_dia_f,dia_atual_f];;


      List<int> dias = [dia_um,dia_dois,dia_tres,dia_quatro,dia_atual];
      List<int> meses = [mes_um,mes_dois,mes_tres,mes_quatro,mes_atual];
      List<int> anos = [ano_um,ano_dois,ano_tres,ano_quatro,ano_atual];
      List<int> meses_distintos = [];

      meses.forEach((element) {
        if(!meses_distintos.contains(element)){
          meses_distintos.add(element);
        }
      });

      print(dias);
      print(meses);
      print(meses_distintos);
      List<double> valores = List.filled(5, 0);


      transactions.forEach((transact) {
        int index = 0;
        dias.forEach((dia) {
          List<String> campos = transact.data.split('-');
          int ano = int.parse(campos[0]);
          int mes = int.parse(campos[1]);
          int dia = int.parse(campos[2]);
          DateTime data_transact = DateTime(ano,mes,dia);
          DateTime data_param = DateTime(anos[index],meses[index],dias[index]);
          if(transact.tipoTransacao == 0){
            if(!(index==0)){
              print(data_transact.difference(data_param).inDays.toString() + (data_param.difference(data_transact).inDays < 8).toString());
              if(data_transact.difference(data_param).inDays < 8 && data_param.month == data_transact.month){
                print(data_transact.difference(data_param).inDays);
                print('adicionar ' + transact.valor.toString() + ' no dia' + data_param.toString());
                valores[index] += transact.valor;
              }

            }else{
              DateTime dia_index = DateTime(anos[index],meses[index],dias[index]);
              if(dia_index.difference(data_transact).inDays < data_transact.day && data_param.month == data_transact.month){
                valores[index] += transact.valor;
              }
            }
          }
          index++;
        });
      });
      int index2 = 0;
      valores.forEach((element) {
        if(index2 > 0){
          if(element == 0.0){
            if(meses[index2] == meses[index2-1]){
              valores[index2] += valores[index2-1];
            }
          }
        }
        index2++;
      });

      return valores
          .mapIndexed(
              (index, element) => PricePoint(x: index.toDouble(), y: element))
          .toList();
      break;
    case '1Y':
      int index = 0;
      List<double> numbers = List.filled(5, 0);
      final formatador = DateFormat('dd-MM');

      final primeiro_dia = hoje.subtract(const Duration(days: 365));
      // final primeiro_dia_f = formatador.format(primeiro_dia);
      int dia_um = primeiro_dia.day;
      int mes_um = primeiro_dia.month;
      int ano_um = primeiro_dia.year;

      final segundo_dia = primeiro_dia.add(const Duration(days: 32));
      // final segundo_dia_f = formatador.format(segundo_dia);
      int dia_dois = segundo_dia.day;
      int mes_dois = segundo_dia.month;
      int ano_dois = segundo_dia.year;

      final terceiro_dia = segundo_dia.add(const Duration(days: 32));
      // final terceiro_dia_f = formatador.format(terceiro_dia);
      int dia_tres = terceiro_dia.day;
      int mes_tres = terceiro_dia.month;
      int ano_tres = terceiro_dia.year;

      final quarto_dia = terceiro_dia.add(const Duration(days: 32));
      // final quarto_dia_f = formatador.format(quarto_dia);
      int dia_quatro = quarto_dia.day;
      int mes_quatro = quarto_dia.month;
      int ano_quatro = quarto_dia.year;

      final quinto_dia = terceiro_dia.add(const Duration(days: 32));
      // final quarto_dia_f = formatador.format(quarto_dia);
      int dia_cinco = quarto_dia.day;
      int mes_cinco = quarto_dia.month;
      int ano_cinco = quarto_dia.year;

      final sexto_dia = terceiro_dia.add(const Duration(days: 32));
      // final quarto_dia_f = formatador.format(quarto_dia);
      int dia_seis = quarto_dia.day;
      int mes_seis = quarto_dia.month;
      int ano_seis = quarto_dia.year;

      final setimo_dia = terceiro_dia.add(const Duration(days: 32));
      // final quarto_dia_f = formatador.format(quarto_dia);
      int dia_sete = quarto_dia.day;
      int mes_sete = quarto_dia.month;
      int ano_sete = quarto_dia.year;

      final oitavo_dia = terceiro_dia.add(const Duration(days: 32));
      // final quarto_dia_f = formatador.format(quarto_dia);
      int dia_oito = quarto_dia.day;
      int mes_oito = quarto_dia.month;
      int ano_oito = quarto_dia.year;

      final nono_dia = terceiro_dia.add(const Duration(days: 32));
      // final quarto_dia_f = formatador.format(quarto_dia);
      int dia_nove = quarto_dia.day;
      int mes_nove = quarto_dia.month;
      int ano_nove = quarto_dia.year;

      int dia_atual = hoje.day;
      int mes_atual = hoje.month;
      int ano_atual = hoje.year;
      // final dia_atual_f = formatador.format(hoje);

      // List<String> lista = [primeiro_dia_f,segundo_dia_f,terceiro_dia_f,quarto_dia_f,dia_atual_f];;


      List<int> dias = [dia_um,dia_dois,dia_tres,dia_quatro,dia_cinco,dia_seis,dia_sete,dia_oito,dia_nove,dia_atual];
      List<int> meses = [mes_um,mes_dois,mes_tres,mes_quatro,mes_cinco,mes_seis,mes_sete,mes_oito,mes_nove,mes_atual];
      List<int> anos = [ano_um,ano_dois,ano_tres,ano_quatro,ano_cinco,ano_seis,ano_sete,ano_oito,ano_nove,ano_atual];
      List<int> meses_distintos = [];

      print(ano_atual.toString() + 'anoa tual');

      meses.forEach((element) {
        if(!meses_distintos.contains(element)){
          meses_distintos.add(element);
        }
      });

      print(dias);
      print(meses);
      print(meses_distintos);
      print(anos);
      List<double> valores = List.filled(5, 0);


      transactions.forEach((transact) {
        int index = 0;
        dias.forEach((dia) {
          List<String> campos = transact.data.split('-');
          int ano = int.parse(campos[0]);
          int mes = int.parse(campos[1]);
          int dia = int.parse(campos[2]);
          DateTime data_transact = DateTime(ano,mes,dia);
          DateTime data_param = DateTime(anos[index],meses[index],dias[index]);
          if(transact.tipoTransacao == 0){
            if(!(index==0)){
              print(data_transact.difference(data_param).inDays.toString() + (data_param.difference(data_transact).inDays < 32 && data_param.month == data_transact.month).toString());
              if(data_param.difference(data_transact).inDays < 32 && data_param.month == data_transact.month){
                print(data_transact.difference(data_param).inDays);
                print('adicionar ' + transact.valor.toString() + ' no dia' + data_param.toString());
                valores[index] += transact.valor;
              }

            }else{
              DateTime dia_index = DateTime(anos[index],meses[index],dias[index]);
              if(dia_index.difference(data_transact).inDays < data_transact.day && data_param.month == data_transact.month){
                valores[index] += transact.valor;
                print('adicionar ' + transact.valor.toString() + ' no dia' + data_param.toString());
              }
            }
          }
          index++;
        });
      });
      int index2 = 0;
      valores.forEach((element) {
        if(index2 > 0){
          if(element == 0.0){
            if(meses[index2] == meses[index2-1]){
              valores[index2] += valores[index2-1];
            }
          }
        }
        index2++;
      });

      return valores
          .mapIndexed(
              (index, element) => PricePoint(x: index.toDouble(), y: element))
          .toList();
      break;

    default:
      break;
  }
  int qtd_total = transactions.length;
  int qtd_periodo = 5;
  List<double> valores = List.filled(qtd_periodo, 0);
  List<String> anos = ['2018','2019','2018','2021','2022'];
  int index = 0;
    anos.forEach((ano) {
      transactions.forEach((element) {
        String dataFormatada = element.data.substring(0,4);
        if(dataFormatada==ano){
          if(element.tipoTransacao==0){
            valores[index]+=element.valor;
          }
        }
      });
      index++;
    });
  return valores
      .mapIndexed(
          (index, element) => PricePoint(x: index.toDouble(), y: element))
      .toList();
}

SideTitles _transforma(String periodo){
  DateTime hoje = DateTime.now();
  List<double> numbers = List.filled(5, 0);
  final formatador = DateFormat('dd-MM');
  int dayslongos = 0;
  int dayscurtos = 0;
  if(periodo == 'Máx'){
    List<String> listaAnual = [];
    for(int i = 4; i >= 0; i--){
      int ano = hoje.year.toInt()-i;
      listaAnual.add(ano.toString());
    }
    return _bottomTitles(listaAnual);
  }else if(periodo == '1M'){
    dayslongos = 32; dayscurtos = 8;
  }else if(periodo == '3M'){
    dayslongos = 96; dayscurtos = 24;
  }else if(periodo == '6M'){
    dayslongos = 182; dayscurtos = 48;
  }else if(periodo == '1Y'){
    dayslongos = 365; dayscurtos = 31;
  }

  List<String> formatados = [];
  print('o periodo é ' + periodo);
  print(periodo!='1Y');
  if(periodo != '1Y'){
    final primeiro_dia = hoje.subtract(Duration(days: dayslongos));
    final primeiro_dia_f = formatador.format(primeiro_dia);
    formatados.add(primeiro_dia_f);

    final segundo_dia = primeiro_dia.add(Duration(days: dayscurtos));
    final segundo_dia_f = formatador.format(segundo_dia);
    formatados.add(segundo_dia_f);

    final terceiro_dia = segundo_dia.add(Duration(days: dayscurtos));
    final terceiro_dia_f = formatador.format(terceiro_dia);
    formatados.add(terceiro_dia_f);

    final quarto_dia = terceiro_dia.add(Duration(days: dayscurtos));
    final quarto_dia_f = formatador.format(quarto_dia);
    formatados.add(quarto_dia_f);
    formatados.add(formatador.format(hoje));
  }else{
    final primeiro_dia = hoje.subtract(Duration(days: dayslongos));
    final primeiro_dia_f = formatador.format(primeiro_dia);
    formatados.add(primeiro_dia_f);

    final segundo_dia = primeiro_dia.add(Duration(days: dayscurtos));
    final segundo_dia_f = formatador.format(segundo_dia);
    formatados.add(segundo_dia_f);

    final terceiro_dia = segundo_dia.add(Duration(days: dayscurtos));
    final terceiro_dia_f = formatador.format(terceiro_dia);
    formatados.add(terceiro_dia_f);

    final quarto_dia = terceiro_dia.add(Duration(days: dayscurtos));
    final quarto_dia_f = formatador.format(quarto_dia);
    formatados.add(quarto_dia_f);
    final quinto_dia = terceiro_dia.add(Duration(days: dayscurtos));
    final quinto_dia_f = formatador.format(quinto_dia);
    formatados.add(quinto_dia_f);
    final sexto_dia = terceiro_dia.add(Duration(days: dayscurtos));
    final sexto_dia_f = formatador.format(sexto_dia);
    formatados.add(sexto_dia_f);
    final setimo_dia = terceiro_dia.add(Duration(days: dayscurtos));
    final setimo_dia_f = formatador.format(setimo_dia);
    formatados.add(setimo_dia_f);
    final oitavo_dia = terceiro_dia.add(Duration(days: dayscurtos));
    final oitavo_dia_f = formatador.format(oitavo_dia);
    formatados.add(oitavo_dia_f);
    final nono_dia = terceiro_dia.add(Duration(days: dayscurtos));
    final nono_dia_f = formatador.format(nono_dia);
    formatados.add(nono_dia_f);
    formatados.add(formatador.format(hoje));
  }

  print('LISTA DO LINE: ' + formatados.toString());


  return _bottomTitles(formatados);

}

SideTitles _bottomTitles(List<String> datas_formatadas) => SideTitles(
  showTitles: true,
  interval: 1,
  getTitlesWidget: (value, meta) {
    String text = ' ';
    switch (value.toInt()) {

      case 0:
        text = datas_formatadas[value.toInt()].replaceAll('-', '/');
        break;
      case 1:
        text = datas_formatadas[value.toInt()].replaceAll('-', '/');
        break;
      case 2:
        text = datas_formatadas[value.toInt()].replaceAll('-', '/');
        break;
      case 3:
        text = datas_formatadas[value.toInt()].replaceAll('-', '/');
        break;
      case 4:
        text = datas_formatadas[value.toInt()].replaceAll('-', '/');
        break;
      case 5:
        text = datas_formatadas[value.toInt()].replaceAll('-', '/');
        break;
      case 6:
        text = datas_formatadas[value.toInt()].replaceAll('-', '/');
        break;
      case 7:
        text = datas_formatadas[value.toInt()].replaceAll('-', '/');
        break;
      case 8:
        text = datas_formatadas[value.toInt()].replaceAll('-', '/');
        break;
      case 9:
        text = datas_formatadas[value.toInt()].replaceAll('-', '/');
        break;
    }

    return Text(text);
  },
);