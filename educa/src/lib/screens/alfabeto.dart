import 'package:flutter/material.dart';
import 'dart:math';

class Alfabeto extends StatefulWidget {
  static const routename = 'alfabeto';
  @override
  _AlfabetoState createState() => _AlfabetoState();
}

class _AlfabetoState extends State<Alfabeto> {
  final _formKey = GlobalKey<FormState>();
  List<String> alfabeto = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z'
  ];

  int numero_sorteado = Random().nextInt(21);
  String letra_escolhida = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Treinamento do alfabeto :)'),
      ),
      body: Column(
        children: [
          SizedBox(height: 30),
          Text(
            "Qual letra vem depois de \"" + alfabeto[numero_sorteado] + "\" ?",
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            child: Form(
              key: _formKey,
              child: TextFormField(
                maxLength: 1,
                //logica
                key: ValueKey('letra'),
                initialValue: letra_escolhida,
                validator: (value) =>
                    value.trim().isEmpty ? 'Digite alguma letra válida' : null,
                onSaved: (value) => letra_escolhida = value,

                //decoração
                decoration: InputDecoration(
                  labelText: 'Letra',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _submit,
            child: Text('Aperte'),
          ),
          ElevatedButton(
              onPressed: () => Navigator.of(context).pushNamed('dica'),
              child: Text('Dica'))
        ],
      ),
    );
  }

  _submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      bool result = alfabeto[numero_sorteado + 1].toLowerCase() ==
          letra_escolhida.toLowerCase();

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
    this.numero_sorteado = Random().nextInt(24);
    setState(() {});
  }
}
