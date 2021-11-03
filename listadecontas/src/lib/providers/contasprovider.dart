import 'package:flutter/foundation.dart';
import 'package:listadecontas/helpers/sql.dart';
import 'package:listadecontas/models/conta.dart';

class ContasProvider with ChangeNotifier {
  List<Conta> all_contas = [];
  final table_name = 'conta';

  int id;

  List<Conta> get all_inserted {
    return [...all_contas];
  }

  ContasProvider();

  ContasProvider.logged_in(this.id);

  Future<void> fetch_data() async {
    final datalist =
        await SQLDatabase.read(table_name, 'user_id', id.toString());

    if (datalist.length == 0) {
      return;
    }

    all_contas = datalist
        .map((e) => Conta.id(e['id'], e['user_id'], e['name'],
            DateTime.parse(e['due_date']), e['description'], e['price']))
        .toList();

    notifyListeners();
  }

  add(String name, DateTime due_date, String description, double price) async {
    Conta c = Conta(this.id, name, due_date, description, price);
    int id = await SQLDatabase.insert(table_name, {
      'user_id': this.id,
      'name': name,
      'due_date': due_date.toIso8601String(),
      'description': description,
      'price': price
    });
    c.id = id;
    this.all_contas.add(c);

    notifyListeners();
  }

  remove(int id) async {
    this.all_contas.removeWhere((element) => element.id == id);
    await SQLDatabase.delete(table_name, id);

    notifyListeners();
  }

  update(int id, Conta c) async {
    int id1 = this.all_contas.indexWhere((element) => element.id == id);
    this.all_contas[id1] = c;

    await SQLDatabase.update(table_name, {
      'user_id': this.id,
      'name': c.name,
      'due_date': c.due_date.toIso8601String(),
      'description': c.description,
      'price': c.price
    });

    notifyListeners();
  }
}
