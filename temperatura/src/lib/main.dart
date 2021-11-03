import 'package:flutter/material.dart';

void main() {
  runApp(Main());
}

class Main extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "teste",
        theme: ThemeData(primarySwatch: Colors.green),
        home: Temperatura());
  }
}

class Temperatura extends StatefulWidget {
  final List<String> opcoes = ['Fahrenheit', 'Kelvin', 'Reamur', 'Rankine'];

  @override
  _TemperaturaState createState() => _TemperaturaState();
}

class _TemperaturaState extends State<Temperatura> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  List<String> opcoes;
  String escolhido;
  double temp_user;
  double temp_convertido;

  void calcular_temperatura() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      setState(() {
        switch (escolhido) {
          case 'Fahrenheit':
            temp_convertido = (temp_user * 9 / 5) + 32;
            break;
          case 'Kelvin':
            temp_convertido = temp_user + 273.15;
            break;
          case 'Reamur':
            temp_convertido = temp_user - (temp_user / 5);
            break;
          case 'Rankine':
            temp_convertido = (temp_user + 273.15) * 9 / 5;
            break;
        }
      });
    }
  }

  void initState() {
    opcoes = widget.opcoes;
    escolhido = opcoes[0];
    temp_user = 0;
    temp_convertido = 32;
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Conversor')),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text('Escolha a unidade:'),
              DropdownButton<String>(
                value: escolhido,
                underline: Container(height: 2, color: Colors.black),
                onChanged: (value) {
                  setState(() {
                    escolhido = value;
                  });
                },
                items: opcoes.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    child: Text(value),
                    value: value,
                  );
                }).toList(),
              ),
              TextFormField(
                initialValue: temp_user.toString(),
                decoration:
                    InputDecoration(labelText: 'Temperatura em Celsius:'),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  temp_user = double.parse(value);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Esse campo não pode estar vazio';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Esse campo requer apenas números';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                  onPressed: calcular_temperatura, child: Text('Calcular')),
              Card(
                  child: Text(
                      'Temperatura convertida:' + temp_convertido.toString()))
            ],
          ),
        ),
      ),
    );
  }
}
