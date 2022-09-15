import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vianey_payments/controls/input_control.dart';
import 'package:vianey_payments/models/clients.dart';
import 'package:vianey_payments/providers/client_form_provider.dart';
import 'package:vianey_payments/services/clients_service.dart';

import 'client_list_screen.dart';

class ClientScreen extends StatelessWidget {
  const ClientScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final clientsService = Provider.of<ClientsService>(context);
    final client = ModalRoute.of(context)!.settings.arguments as Client;

    return ChangeNotifierProvider(
        create: (_) => ClientFormProvider(client),
        child: _ClientScreenState(clientService: clientsService));
  }
}

class _ClientScreenState extends StatelessWidget {
  const _ClientScreenState({Key? key, required this.clientService})
      : super(key: key);

  final ClientsService clientService;

  @override
  Widget build(BuildContext context) {
    final clientForm = Provider.of<ClientFormProvider>(context);
    final clientF = clientForm.client;

    final client = ModalRoute.of(context)!.settings.arguments as Client;
    final titleHeader =
        client.id.contains('*') ? 'Agregar cliente' : 'Actualizar cliente';
    final titleBtn = client.id.contains('*') ? 'Agregar' : 'Actualizar';
    final createUpdate = client.id.contains('*') ? true : false;
    return Scaffold(
        appBar: AppBar(
          title: Text(titleHeader),
          actions: [
            IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ClientListScreen()));
                })
          ],
        ),
        body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 50),
            children: [
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0)),
                child: Form(
                    key: clientForm.formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const <Widget>[
                                Text(
                                  'Información Personal',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 25.0),
                                )
                              ],
                            ),
                          ),
                          TextFormField(
                            initialValue: client.name,
                            autocorrect: false,
                            keyboardType: TextInputType.name,
                            onChanged: (value) => clientF?.name = value,
                            // ignore: body_might_complete_normally_nullable
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'El nombre es obligatorio';
                              }
                            },
                            decoration: InputControl.authInputDecoration(
                                hintText: 'Nombre',
                                labelText: 'Nombre',
                                prefixIcon: Icons.person),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            initialValue: client.lastname,
                            autocorrect: false,
                            onChanged: (value) => clientF?.lastname = value,
                            keyboardType: TextInputType.text,
                            decoration: InputControl.authInputDecoration(
                                hintText: 'Apellido',
                                labelText: 'Apellido',
                                prefixIcon: Icons.person),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            initialValue: client.address,
                            autocorrect: false,
                            onChanged: (value) => clientF?.address = value,
                            keyboardType: TextInputType.text,
                            decoration: InputControl.authInputDecoration(
                                hintText: 'Dirección',
                                labelText: 'Dirección',
                                prefixIcon: Icons.home),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            initialValue: client.phone,
                            autocorrect: false,
                            keyboardType: TextInputType.phone,
                            onChanged: (value) => clientF?.phone = value,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^(\d+)?\.?\d{0,2}'))
                            ],
                            // ignore: body_might_complete_normally_nullable
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'El Teléfono es obligatorio';
                              }
                              if (value.length < 10 || value.length > 10) {
                                return 'El Teléfono debe tener 10 caracteres';
                              }
                            },
                            decoration: InputControl.authInputDecoration(
                                hintText: 'Teléfono',
                                labelText: 'Teléfono',
                                prefixIcon: Icons.phone),
                          ),
                          Center(
                              child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                disabledColor: Colors.grey,
                                elevation: 0,
                                color: const Color.fromRGBO(118, 35, 109, 1),
                                child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 80, vertical: 15),
                                    child: Text(
                                      titleBtn,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    )),
                                onPressed: () async {
                                  if (!clientForm.isValidForm()) return;

                                  client.status = 'activo';
                                  if (createUpdate) {
                                    client.created = DateTime.now();
                                    await clientService.save(client, true);
                                  } else {
                                    await clientService.update(client);
                                  }

                                  // ignore: use_build_context_synchronously
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ClientListScreen()));
                                }),
                          ))
                        ],
                      ),
                    )),
              )
            ]));
  }
}
