import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:listadecontas/models/conta.dart';
import 'package:listadecontas/providers/contasprovider.dart';
import 'package:provider/provider.dart';

class Bills extends StatefulWidget {
  final Conta c;
  Bills({this.c});

  @override
  _BillsState createState() => _BillsState();
}

class _BillsState extends State<Bills> {
  final GlobalKey<FormState> globalKey = GlobalKey();
  String name;
  String description;
  DateTime due_date;
  double price = 0.0;
  bool update = false;
  void initState() {
    super.initState();
    if (widget.c != null) {
      update = true;

      name = widget.c.name;
      due_date = widget.c.due_date;
      description = widget.c.description;
      price = widget.c.price;
    }
  }

  criar_conta() async {
    if (!globalKey.currentState.validate()) {
      return false;
    }

    globalKey.currentState.save();

    if (update) {
      widget.c.name = name;
      widget.c.due_date = due_date;
      widget.c.description = description;
      widget.c.price = price;

      await Provider.of<ContasProvider>(context, listen: false)
          .update(widget.c.id, widget.c);
    } else {
      await Provider.of<ContasProvider>(context, listen: false)
          .add(name, due_date, description, price);
    }

    Navigator.of(context).pop();
  }

  escolher_data() async {
    DateTime today = DateTime.now().add(Duration(days: 1));
    await showDatePicker(
            context: context,
            initialDate: today,
            firstDate: today,
            lastDate: DateTime(today.year + 1))
        .then((DateTime value) {
      setState(() {
        due_date = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (due_date != null) print(due_date.toIso8601String());
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar conta'),
        centerTitle: true,
      ),
      body: Form(
        key: globalKey,
        child: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              TextFormField(
                initialValue: price.toString(),
                decoration: InputDecoration(
                    border: OutlineInputBorder(), prefix: Text('R\$')),
                keyboardType: TextInputType.number,
                onSaved: (user_inserted_value) {
                  price = double.parse(user_inserted_value);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Digite um valor';
                  } else if (double.tryParse(value) == null) {
                    return 'Digite um número';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                initialValue: name,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Nome'),
                keyboardType: TextInputType.name,
                onSaved: (user_inserted_value) {
                  name = user_inserted_value;
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Digite um valor';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                initialValue: description,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Descrição'),
                keyboardType: TextInputType.name,
                onSaved: (user_inserted_value) {
                  description = user_inserted_value;
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Digite um valor';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  due_date == null
                      ? Text('Nenhuma data selecionada')
                      : Text('Data selecionada: \n' +
                          DateFormat('dd/MM/yyyy').format(due_date)),
                  ElevatedButton(
                      onPressed: escolher_data, child: Text('Escolha a data'))
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              ElevatedButton(
                  onPressed: criar_conta, child: Text('Adicionar conta'))
            ],
          ),
        )),
      ),
    );
  }
}
