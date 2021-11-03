import 'package:flutter/material.dart';
import 'package:listacontatos/models/contato.dart';
import 'package:listacontatos/providers/contatosprovider.dart';
import 'package:provider/provider.dart';
import 'add_bills.dart';
import 'contact_info.dart';

class ContactFinder extends SearchDelegate<Contato> {
  Contato c;
  bool is_on_result_screen = false;

  @override
  List<Widget> buildActions(BuildContext context) {
    return is_on_result_screen
        ? []
        : [
            IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  query = '';
                })
          ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () {
          if (is_on_result_screen) {
            is_on_result_screen = false;
            showSuggestions(context);
          } else {
            Navigator.of(context).pop();
          }
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatarWithText(
              icon: Icons.create,
              onTap: () async {
                await Navigator.of(context).push(
                    MaterialPageRoute<void>(builder: (context) => Bills(c: c)));
              },
              text: 'Editar',
            ),
            SizedBox(width: 15),
            CircleAvatarWithText(
              icon: Icons.delete,
              onTap: () async {
                await Provider.of<ContatosProvider>(context, listen: false)
                    .remove(c.id);
                is_on_result_screen = false;
                showSuggestions(context);
              },
              text: 'Deletar',
            )
          ],
        ),
        SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            c.img_path == 'none'
                ? CircleAvatar(
                    radius: 25,
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: Text(c.name[0]),
                    ),
                  )
                : CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(c.img_path),
                  ),
            SizedBox(width: 20),
            Column(children: [
              Text(c.name, textAlign: TextAlign.start),
              Text(c.phone, textAlign: TextAlign.start),
              Text(c.email, textAlign: TextAlign.start),
              Text(c.cep, textAlign: TextAlign.start),
              Text(c.address, textAlign: TextAlign.start)
            ])
          ],
        )
      ],
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Consumer<ContatosProvider>(builder: (context, contas, _) {
      List<Contato> filtered_contacts = [];

      if (query.isNotEmpty) {
        filtered_contacts = contas.all_inserted
            .where((element) =>
                element.name.toUpperCase().startsWith(query.toUpperCase()))
            .toList();
      } else {
        filtered_contacts = contas.all_inserted;
      }
      if (filtered_contacts.length > 0 && query.isNotEmpty) {
        c = filtered_contacts[0];
      }

      return ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: filtered_contacts.length,
          itemBuilder: (ctx, index) => ContaCard(() {
                this.is_on_result_screen = true;
                this.c = filtered_contacts[index];
                showResults(context);
              }, conta: filtered_contacts[index]));
    });
  }
}

class ContaCard extends StatelessWidget {
  final Contato conta;
  final Function onTap;
  const ContaCard(this.onTap, {Key key, this.conta}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CircleAvatar avatar = conta.img_path == 'none'
        ? CircleAvatar(
            radius: 25,
            child: FittedBox(
              fit: BoxFit.fill,
              child: Text(conta.name[0]),
            ),
          )
        : CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(conta.img_path),
          );

    return Card(
      elevation: 8,
      child: ListTile(
        trailing: GestureDetector(
          child: Icon(Icons.delete, color: Colors.red),
          onTap: () async {
            await Provider.of<ContatosProvider>(context, listen: false)
                .remove(conta.id);
          },
        ),
        onTap: () {
          this.onTap();
        },
        leading: avatar,
        title: Text(conta.name),
        subtitle: Text(conta.phone),
      ),
    );
  }
}
