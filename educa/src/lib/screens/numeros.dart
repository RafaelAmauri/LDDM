import 'package:flutter/material.dart';
import 'dart:math';

class Numeros extends StatefulWidget {
  static const routename = 'numeros';
  @override
  _NumerosState createState() => _NumerosState();
}

class _NumerosState extends State<Numeros> {
  final _formKey = GlobalKey<FormState>();

  int numero_sorteado1 = Random().nextInt(10);
  int numero_sorteado2 = Random().nextInt(10);

  int numero_escolhido = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Treinamento de números :)'),
      ),
      body: Column(
        children: [
          SizedBox(height: 30),
          Text(
            "Quanto é " +
                numero_sorteado1.toString() +
                " + " +
                numero_sorteado2.toString() +
                " ?",
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            child: Form(
              key: _formKey,
              child: TextFormField(
                maxLength: 2,
                //logica
                key: ValueKey('letra'),
                initialValue: numero_escolhido.toString(),
                validator: (value) =>
                    value.trim().isEmpty ? 'Digite algum número válido' : null,
                onSaved: (value) => numero_escolhido = int.parse(value),

                //decoração
                decoration: InputDecoration(
                  labelText: 'Número',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _submit,
            child: Text('Aperte'),
          )
        ],
      ),
    );
  }

  _submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      bool result = (numero_sorteado1 + numero_sorteado2) == numero_escolhido;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Center(child: Text(result ? 'Parabéns' : 'Foi Quase')),
          actionsPadding: EdgeInsets.symmetric(horizontal: 100),
          actions: [
            result
                ? ElevatedButton(
                    onPressed: () => {newRandom(), Navigator.pop(context)},
                    child: Container(
                      child: Text('Voltar'),
                    ),
                  )
                : ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Container(
                      child: Text('Voltar'),
                    ),
                  )
          ],
        ),
      );
    }
  }

  newRandom() {
    this.numero_sorteado1 = Random().nextInt(10);
    this.numero_sorteado2 = Random().nextInt(10);
    setState(() {});
  }
}
