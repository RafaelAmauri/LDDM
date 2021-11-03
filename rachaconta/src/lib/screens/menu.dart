import 'package:flutter/material.dart';
import 'package:rachaconta/screens/result.dart';

class Menu extends StatefulWidget {
  static const routename = 'rota';
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final GlobalKey<FormState> globalKey = GlobalKey();
  double total_price = 0.0;
  double drinks_price = 0.0;
  double waiter_tip_percentage = 0.0;

  int num_people = 0;
  int num_alcoholic_people = 0;

  bool contains_alcohol = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Rachador de conta')),
      body: Form(
        key: globalKey,
        child: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              TextFormField(
                initialValue: total_price.toString(),
                decoration: InputDecoration(
                    border: OutlineInputBorder(), prefix: Text('R\$')),
                keyboardType: TextInputType.number,
                onSaved: (user_inserted_value) {
                  total_price = double.parse(user_inserted_value);
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
              TextFormField(
                initialValue: num_people.toString(),
                decoration: InputDecoration(labelText: 'Número de pessoas: '),
                keyboardType: TextInputType.number,
                onSaved: (user_inserted_value) {
                  num_people = int.parse(user_inserted_value);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Digite um valor';
                  } else if (int.tryParse(value) == null) {
                    return 'Digite um número';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: waiter_tip_percentage.toString(),
                decoration:
                    InputDecoration(labelText: 'Porcentagem do garçom: '),
                keyboardType: TextInputType.number,
                onSaved: (user_inserted_value) {
                  waiter_tip_percentage = double.parse(user_inserted_value);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Digite um valor';
                  } else if (double.tryParse(value) == null) {
                    return 'Digite um número';
                  } else if (double.parse(value) < 0 &&
                      double.parse(value) > 100) {
                    return 'A gorjeta do garçom deve ser entre 0% e 100%';
                  }
                  return null;
                },
              ),
              CheckboxListTile(
                  title: Text('Contém alcool?'),
                  value: contains_alcohol,
                  onChanged: (value) {
                    setState(() {
                      contains_alcohol = value;
                    });
                  }),
              if (contains_alcohol) ...buildContainsAlcoholTextFormField(),
              ElevatedButton(onPressed: calculate, child: Text('Calcular'))
            ],
          ),
        )),
      ),
    );
  }

  List<Widget> buildContainsAlcoholTextFormField() {
    return [
      TextFormField(
        enabled: contains_alcohol,
        initialValue: drinks_price.toString(),
        decoration:
            InputDecoration(border: OutlineInputBorder(), prefix: Text('R\$')),
        keyboardType: TextInputType.number,
        onSaved: (user_inserted_value) {
          drinks_price = double.parse(user_inserted_value);
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
      TextFormField(
        enabled: contains_alcohol,
        initialValue: num_alcoholic_people.toString(),
        decoration: InputDecoration(labelText: 'Número de pessoas: '),
        keyboardType: TextInputType.number,
        onSaved: (user_inserted_value) {
          num_alcoholic_people = int.parse(user_inserted_value);
        },
        validator: (value) {
          if (value.isEmpty) {
            return 'Digite um valor';
          } else if (int.tryParse(value) == null) {
            return 'Digite um número';
          }
          return null;
        },
      )
    ];
  }

  void calculate() {
    if (globalKey.currentState.validate()) {
      globalKey.currentState.save();


      if (num_alcoholic_people > num_people) {
        showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                title: Text('Erro'),
                content: Text(
                    'O número de pessoas bebendo não pode ser maior que o número de pessoas na mesa')));

        return ;
      }

      double waiter_tip_value = (waiter_tip_percentage / 100) * total_price;
      total_price += waiter_tip_value;

      double individual_price = (total_price - drinks_price) / num_people;
      double alcohol_price;
      if (contains_alcohol) {
        alcohol_price =
            individual_price + (drinks_price / num_alcoholic_people);
      } else {
        alcohol_price = -1;
      }

      Navigator.of(context).pushNamed(Result.routename, arguments: {
        'Preço individual': individual_price,
        'Preço alcool': alcohol_price,
        'Preço garçom': waiter_tip_value,
        'Preço total': total_price
      });
    }
  }
}
