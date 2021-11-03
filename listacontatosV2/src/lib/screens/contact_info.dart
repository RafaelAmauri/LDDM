import 'package:flutter/material.dart';
import 'package:listacontatos/models/contato.dart';
import 'package:listacontatos/providers/contatosprovider.dart';
import 'package:provider/provider.dart';
import 'add_bills.dart';

class ContactInfo extends StatelessWidget {
  static const routename = 'contact_info';
  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments as String;
    final contato =
        Provider.of<ContatosProvider>(context, listen: false).find(id);

    return Scaffold(
      appBar: AppBar(title: Text('Informações')),
      body: Column(
        children: [
          SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatarWithText(
                icon: Icons.create,
                onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(
                    builder: (context) => Bills(c: contato))),
                text: 'Editar',
              ),
              SizedBox(width: 15),
              CircleAvatarWithText(
                icon: Icons.delete,
                onTap: () async {
                  await Provider.of<ContatosProvider>(context, listen: false)
                      .remove(contato.id);
                  Navigator.of(context).pop();
                },
                text: 'Deletar',
              )
            ],
          ),
          SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              contato.img_path == 'none'
                  ? CircleAvatar(
                      radius: 25,
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: Text(contato.name[0]),
                      ),
                    )
                  : CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(contato.img_path),
                    ),
              SizedBox(width: 20),
              Column(children: [
                Text(contato.name, textAlign: TextAlign.start),
                Text(contato.phone, textAlign: TextAlign.start),
                Text(contato.email, textAlign: TextAlign.start),
                Text(contato.cep, textAlign: TextAlign.start),
                Text(contato.address, textAlign: TextAlign.start)
              ])
            ],
          )
        ],
      ),
    );
  }
}

class CircleAvatarWithText extends StatelessWidget {
  const CircleAvatarWithText(
      {Key key, @required this.icon, @required this.onTap, @required this.text})
      : super(key: key);

  final IconData icon;
  final Function onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
            onTap: () {
              this.onTap();
            },
            child: CircleAvatar(
              child: Icon(icon),
            )),
        Text(this.text)
      ],
    );
  }
}
