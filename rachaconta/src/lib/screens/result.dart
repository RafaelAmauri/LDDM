import 'package:flutter/material.dart';

class Result extends StatelessWidget {
  static const routename = 'resultado';

  @override
  Widget build(BuildContext context) {
    final results =
        ModalRoute.of(context).settings.arguments as Map<String, double>;

    return Scaffold(
      appBar: AppBar(
        title: Text('Resultado: '),
      ),
      
      body: 
      Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text('Preço total: R\$' + results['Preço total'].toStringAsFixed(2)),
              Text('Preço para pessoas que não beberam: R\$' +
                  results['Preço individual'].toStringAsFixed(2)),
              Text('Preço do garçom: R\$' + results['Preço garçom'].toStringAsFixed(2)),
              if (results['Preço alcool'] == -1)
                Text('Ninguém bebeu')
              else
                Text('Preço do alcool: R\$' + results['Preço alcool'].toStringAsFixed(2))
            ],
          ),
        ),
      ),
    );
  }
}
