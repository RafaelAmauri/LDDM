import 'package:flutter/material.dart';
import 'package:listadecontas/models/conta.dart';
import 'package:listadecontas/providers/auth_provider.dart';
import 'package:listadecontas/providers/contasprovider.dart';
import 'package:provider/provider.dart';

import 'add_bills.dart';

class Homepage extends StatefulWidget {
  static const routename = 'homepage';
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contas'),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              child: DrawerHeader(
                child: Text(
                  'Contas',
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                ),
                decoration:
                    BoxDecoration(color: Theme.of(context).primaryColor),
              ),
            ),
            ListTile(
              title: Text('Sair'),
              onTap: () async {
                await Provider.of<AuthProvider>(context, listen: false)
                    .sign_out();
              },
              leading: Icon(
                Icons.exit_to_app,
                color: Colors.red,
              ),
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute<void>(builder: (context) => Bills()))),
      body: FutureBuilder(
        future:
            Provider.of<ContasProvider>(context, listen: false).fetch_data(),
        builder: (ctx, result) =>
            result.connectionState == ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Consumer<ContasProvider>(
                        builder: (context, contas, _) => ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: contas.all_contas.length,
                            itemBuilder: (ctx, index) =>
                                ContaCard(conta: contas.all_contas[index])))),
      ),
    );
  }
}

class ContaCard extends StatelessWidget {
  final Conta conta;
  const ContaCard({Key key, this.conta}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: ListTile(
        trailing: GestureDetector(
          child: Icon(Icons.delete, color: Colors.red),
          onTap: () async {
            await Provider.of<ContasProvider>(context, listen: false)
                .remove(conta.id);
          },
        ),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute<void>(
              builder: (context) => Bills(c: this.conta)));
        },
        leading: CircleAvatar(
          radius: 25,
          child: FittedBox(
            fit: BoxFit.fill,
            child: Text(conta.due_date_formatted),
          ),
        ),
        title: Text(conta.name),
        subtitle: Text(conta.description),
      ),
    );
  }
}
