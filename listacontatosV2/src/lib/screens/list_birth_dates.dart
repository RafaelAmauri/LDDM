import 'package:flutter/material.dart';
import 'package:listacontatos/models/contato.dart';
import 'package:listacontatos/providers/contatosprovider.dart';
import 'package:provider/provider.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

class ListOfBirthdates extends StatelessWidget {
  static const routename = 'birth_dates_screen';

  @override
  Widget build(BuildContext context) {
    List<String> months = [
      'Janeiro',
      'Fevereiro',
      'Março',
      'Abril',
      'Maio',
      'Junho',
      'Julho',
      'Agosto',
      'Setembro',
      'Outubro',
      'Novembro',
      'Dezembro'
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Listas de Aniversários')),
      body: SingleChildScrollView(
          child: Consumer<ContatosProvider>(
        builder: (ctx, contatos, _) => GroupedListView<Contato, int>(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          elements: contatos.contact_by_birthday,
          groupBy: (element) => DateTime.parse(element.birthday).month,
          groupSeparatorBuilder: (group_by_value) =>
              Text(months[group_by_value - 1]),
          itemBuilder: (context, element) => ContaCard(conta: element),
          groupComparator: (item1, item2) => item1.compareTo(item2),
          useStickyGroupSeparators: true,
          floatingHeader: true,
        ),
      )),
    );
  }
}

class ContaCard extends StatelessWidget {
  final Contato conta;
  const ContaCard({Key key, this.conta}) : super(key: key);

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
        leading: avatar,
        title: Text(conta.name),
        subtitle: Text(conta.phone),
      ),
    );
  }
}
