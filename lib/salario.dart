import 'package:flutter/material.dart';

class Salario extends StatefulWidget {
  @override
  _SalarioState createState() => _SalarioState();
}

class _SalarioState extends State<Salario> {
  final TextEditingController _salarioBruto = TextEditingController();
  var aliquotaInss = 0.0;
  var descontoInss = 0.0;
  var aliquotaIrrf = 0.0;
  var descontoIrrf = 0.0;
  var salarioLiquido = 0.0;

  var _isResultadoVisible = false;

  _calcularClick() {
    var salario = double.parse(_salarioBruto.text);

    var deducaoInss = 0.0;
    if (salario <= 1045) {
      aliquotaInss = 7.5;
    } else if (salario > 1045 && salario <= 2089.60) {
      aliquotaInss = 9.0;
      deducaoInss = 15.67;
    } else if (salario > 2089.60 && salario <= 3134.40) {
      aliquotaInss = 12.0;
      deducaoInss = 78.36;
    } else if (salario > 3134.40 && salario <= 6106.06) {
      aliquotaInss = 14.0;
      deducaoInss = 141.05;
    }

    if (salario > 6106.06) {
      descontoInss = 713.10;
    } else {
      descontoInss = salario * aliquotaInss / 100 - deducaoInss;
    }

    var deducaoIrrf = 0.0;
    if (salario > 1903.98) {
      if (salario > 1903.98 && salario <= 2826.65) {
        aliquotaIrrf = 7.5;
        deducaoIrrf = 142.80;
      } else if (salario > 2826.65 && salario <= 3751.05) {
        aliquotaIrrf = 15;
        deducaoIrrf = 354.80;
      } else if (salario > 3751.05 && salario <= 4664.68) {
        aliquotaIrrf = 22.5;
        deducaoIrrf = 636.13;
      } else if (salario >= 4664.69) {
        aliquotaIrrf = 27.5;
        deducaoIrrf = 869.36;
      }
      descontoIrrf = (salario - descontoInss) * aliquotaIrrf / 100.0 - deducaoIrrf;
    }

    setState(() {
      salarioLiquido = salario - descontoIrrf - descontoInss;
      _isResultadoVisible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cálculo Salário Líquido'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(hintText: 'Salário Bruto'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              controller: _salarioBruto,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RaisedButton(
                child: Text('Calcular'),
                color: Colors.teal,
                textColor: Colors.white,
                onPressed: _calcularClick,
              ),
              RaisedButton(
                child: Text('Limpar'),
                color: Colors.teal,
                textColor: Colors.white,
                onPressed: () => {
                  setState(() {
                    salarioLiquido = 0;
                    _salarioBruto.text = "";
                    _isResultadoVisible = false;
                  })
                },
              )
            ],
          ),
          Visibility(
            visible: _isResultadoVisible,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Salário Líquido: R\$${salarioLiquido.toStringAsFixed(2)}')
              ],
            ),
          )
        ],
      ),
    );
  }
}