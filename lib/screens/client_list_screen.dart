import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vianey_payments/models/models.dart';
import 'package:vianey_payments/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../services/services.dart';

class ClientListScreen extends StatefulWidget {
  const ClientListScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ClientListScreenState createState() => _ClientListScreenState();
}

class _ClientListScreenState extends State<ClientListScreen> {
  Icon customIcon = const Icon(Icons.search);
  Widget customText = const Text('Clientes');
  List<Client> clientsList = [];
  List<Client> auxClients = [];
  int cont = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final clientReset = ModalRoute.of(context)!.settings.arguments as ClientReset;
    final clientsService = Provider.of<ClientsService>(context);
    final loginService = Provider.of<AuthService>(context);

    if (clientsService.isLoading) return const Loading();
    clientsList = clientsService.clients;
    if (cont == 0) {
      auxClients = clientsList;
    }
    cont++;

    if (clientReset.reset! && clientReset.client != null) {
      var clientId = clientReset.client!.id;
      int index = clientsList.indexWhere((element) => element.id == clientId);
      clientsList[index] = clientReset.client!;
    }

    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              loginService.logout();
              Navigator.popAndPushNamed(context, 'login');
            },
          ),
          actions: [
            IconButton(
                icon: customIcon,
                onPressed: () {
                  setState(() {
                    if (customIcon.icon == Icons.search) {
                      customIcon = const Icon(Icons.cancel);
                      customText = TextField(
                          textInputAction: TextInputAction.go,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Buscar, Nombre o Celular'),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18),
                          onChanged: (value) async => {
                                await Future.delayed(
                                    const Duration(seconds: 1)),
                                _findClient(value)
                              });
                    } else {
                      customIcon = const Icon(Icons.search);
                      customText = const Text('Clientes');
                      setState(() {
                        auxClients = clientsList;
                      });
                    }
                  });
                }),
          ],
          title: customText),
      body: auxClients.isEmpty
          ? const CardNoContent()
          : _clientListTable(context, auxClients),
      floatingActionButton: _floatingActionButton(context),
    );
  }

  _clientListTable(context, clientsService) {
    final formatter  = NumberFormat.currency(locale: 'es_MX', decimalDigits: 2, name: '');
    return ListView(
      children: [
        Card(
          color: const Color.fromARGB(118, 35, 109, 100),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
          child: SizedBox(
            width: double.infinity,
            child: DataTable(
                showCheckboxColumn: false,
                columnSpacing: 15.0,
                columns: const [
                  DataColumn(label: Text('')),
                  DataColumn(
                      label: Text('Nombre', style: TextStyle(fontSize: 17))),
                  DataColumn(
                      label: Text('Telefono', style: TextStyle(fontSize: 17))),
                  DataColumn(
                      label: Text('Saldo', style: TextStyle(fontSize: 17))),
                ],
                rows: auxClients
                    .map<DataRow>((e) => DataRow(
                            onSelectChanged: (b) {
                              Navigator.pushNamed(context, 'clientDetail',
                                  arguments: e);
                            },
                            cells: [
                              DataCell(
                                const Icon(Icons.edit,
                                    color: Colors.black45, size: 27),
                                onTap: () => {
                                  Navigator.pushNamed(context, 'client',
                                      arguments: e)
                                },
                              ),
                              DataCell(Text(_cutString('${e.name} ${e.lastname}', 11),
                                  style: const TextStyle(fontSize: 15))),
                              DataCell(Text(e.phone.toString(),
                                  style: const TextStyle(fontSize: 15))),
                              DataCell(Text('\$${ formatter.format(e.balance) }',// e.balance.toStringAsFixed(2)}',
                                  style: const TextStyle(fontSize: 15))),
                            ]))
                    .toList()),
          ),
        ),
      ],
    );
  }

  _floatingActionButton(context) {
    return FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, 'client',
            arguments: Client(
                id: '*',
                name: '',
                lastname: '',
                balance: 0,
                phone: '',
                status: '',
                created: DateTime.now(),)),
        tooltip: 'Increment',
        child: const Icon(Icons.add));
  }

  _findClient(String value) {
    setState(() {
      auxClients = clientsList
          .where((client) =>
              client.name.toLowerCase().contains(value.toLowerCase()) ||
              client.lastname.toLowerCase().contains(value.toLowerCase()) ||
              client.phone.toLowerCase().contains(value.toLowerCase()))
          .toList();
      debugPrint(auxClients.length.toString());
    });
  }

  _cutString(String value, int length) {
    var res = value.length < 11 ? value : '${value.substring(0, length)}...';
    return res;
  }
}
