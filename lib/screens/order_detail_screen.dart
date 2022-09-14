import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:group_button/group_button.dart';
import 'package:vianey_payments/models/models.dart';
import 'package:vianey_payments/controls/input_control.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:vianey_payments/providers/order_form_provider.dart';
import 'package:vianey_payments/services/clients_service.dart';

class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final clientsService = Provider.of<ClientsService>(context);
    final clientCustom =
        ModalRoute.of(context)!.settings.arguments as ClientCustom;
    Client client = clientCustom.client as Client;
    String id = clientCustom.id ?? '*';
    final order = id.contains('*')
        ? Order(
            tempId: '',
            orderDate: '',
            orderStatus: '',
            orderType: '',
            total: 0,
            comment: '',
            isExpanded: false,
            isNewOrder: true)
        : client.orders!.isNotEmpty
            ? client.orders?.where((element) => element.tempId == id).first
            : null;
    final orderTem = order!.copy();
    var title = 'Agregar orden a:';
    var titleBtn = 'Agregar: ';
    if (!order.isNewOrder) {
      title = 'Acualizar orden a:';
      titleBtn = 'Acualizar';
    }

    return ChangeNotifierProvider(
        create: (_) => OrderFormProvider(order),
        child: _OrderScreenState(
            client: client,
            clientService: clientsService,
            order: order,
            orderTem: orderTem,
            title: title,
            titleBtn: titleBtn
            ));
  }
}

class _OrderScreenState extends StatelessWidget {
  const _OrderScreenState(
      {Key? key,
      required this.client,
      required this.clientService,
      required this.order,
      required this.orderTem,
      required this.title,
      required this.titleBtn})
      : super(key: key);
  final Client client;
  final ClientsService clientService;
  final Order? order;
  final Order? orderTem;
  final String title;
  final String titleBtn;

  @override
  Widget build(BuildContext context) {
    final formatter  = NumberFormat.currency(locale: 'es_MX', decimalDigits: 2, name: '');
    final orderForm = Provider.of<OrderFormProvider>(context);
    final orderF = orderForm.order;
    var now = DateTime.now();
    var hasStatus = false;
    var hasType = false;
    var val = false;
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => { 
              if (client.orders!.isNotEmpty) {
                client.orders![client.orders!.indexWhere((element) => element.tempId == orderTem!.tempId)] = orderTem!
              },
              Navigator.popAndPushNamed(context, 'clientDetail', arguments: client)
            },
          ),
          title: const Text('Agregar orden')
        ),
        body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            children: [
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0)),
                child: Form(
                    key: orderForm.formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            // ignore: prefer_interpolation_to_compose_strings
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  title + client.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20.0),
                                )
                              ],
                            ),
                          ),
                          TextFormField(
                            // ignore: unrelated_type_equality_checks
                            initialValue: order?.orderDate != ""
                                ? order?.orderDate
                                : (order?.orderDate =
                                    DateFormat('dd/MM/yyyy').format(now)),
                            autocorrect: false,
                            enabled: false,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputControl.authInputDecoration(
                                hintText: 'Fecha',
                                labelText: 'Fecha (Dia-Mes-Año)',
                                prefixIcon: Icons.date_range_outlined),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                              // ignore: unrelated_type_equality_checks
                              initialValue: order?.comment,
                              autocorrect: false,
                              keyboardType: TextInputType.text,
                              maxLines: 2,
                              onChanged: (value) => orderF?.comment = value,
                              // ignore: body_might_complete_normally_nullable
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Descripción es obligatorio';
                                }
                              },
                              decoration: InputControl.authInputDecoration(
                                  hintText: 'Descripción',
                                  labelText: 'Descripción',
                                  prefixIcon: Icons.comment)),
                          const SizedBox(height: 10),
                          TextFormField(
                              // ignore: unrelated_type_equality_checks
                              initialValue:
                                  '\$${order?.total ?? (formatter.format(order?.total = 0))}',
                              // enabled: false,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                //FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))
                                CurrencyTextInputFormatter(
                                    decimalDigits: 2, symbol: '\$')
                              ],
                              onChanged: (value) => {
                                    value = value.replaceFirst("\$", ''),
                                    value = value.replaceAll(",", ''),
                                    if (double.tryParse(value) == null)
                                      {orderF?.total = 0}
                                    else
                                      {orderF?.total = double.parse(value)}
                                  },
                              // ignore: body_might_complete_normally_nullable
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Total es obligatorio';
                                }
                              },
                              decoration: InputControl.authInputDecoration(
                                  hintText: 'Total',
                                  labelText: 'Total de está orden',
                                  prefixIcon: Icons.monetization_on)),
                          const SizedBox(height: 10),
                          const Text('Tipo de pago:', style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15.0)),
                          const SizedBox(height: 8),
                          Center(
                            child: GroupButton(
                                spacing: 5,
                                isRadio: true,
                                direction: Axis.horizontal,
                                onSelected: (index, isSelected) => {
                                  hasType = true,
                                  index == 0 ? orderF?.orderType = 'credito' : orderF?.orderType = 'contado',
                                },
                                buttons: const ["Crédito","Contado"],
                                selectedButton: order?.orderType != null && order?.orderType != "" ? 
                                (order?.orderType == 'credito' ? 0 : 1 ) : 1,
                                // selectedButtons: const [0, 1], /// [List<int>] after 2.2.1 version 
                                selectedTextStyle: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Color.fromRGBO(118, 35, 109, 1),
                                ),
                                unselectedTextStyle: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                ),
                                selectedColor: Colors.white,
                                unselectedColor: Colors.grey[300],
                                selectedBorderColor: const Color.fromRGBO(118, 35, 109, 1),
                                unselectedBorderColor: Colors.grey[500],
                                borderRadius: BorderRadius.circular(5.0),
                                selectedShadow: const <BoxShadow>[BoxShadow(color: Colors.transparent)],
                                unselectedShadow: const <BoxShadow>[BoxShadow(color: Colors.transparent)],
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text('Estatus de orden:', style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15.0)),
                          const SizedBox(height: 8),
                          Center(
                            child: GroupButton(
                                spacing: 5,
                                isRadio: true,
                                direction: Axis.horizontal,
                                onSelected: (index, isSelected) =>{
                                  hasStatus = true,
                                  index == 0 ? orderF?.orderStatus = 'pedido'  : index == 1 ? orderF?.orderStatus = 'entregado' : orderF?.orderStatus = 'cancelado',
                                },
                                buttons: const ["Pedido","Entregado","Cancelado"],
                                selectedButton: order?.orderStatus != null && order?.orderStatus != "" ? (order?.orderStatus == 'pedido' ? 0  : order?.orderStatus == 'entregado' ? 1 : 2) : 0,
                                // selectedButtons: const [0, 1], /// [List<int>] after 2.2.1 version 
                                selectedTextStyle: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Color.fromRGBO(118, 35, 109, 1),
                                ),
                                unselectedTextStyle: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                ),
                                selectedColor: Colors.white,
                                unselectedColor: Colors.grey[300],
                                selectedBorderColor: const Color.fromRGBO(118, 35, 109, 1),
                                unselectedBorderColor: Colors.grey[500],
                                borderRadius: BorderRadius.circular(5.0),
                                selectedShadow: const <BoxShadow>[BoxShadow(color: Colors.transparent)],
                                unselectedShadow: const <BoxShadow>[BoxShadow(color: Colors.transparent)],
                            ),
                          ),
                          const SizedBox(height: 10),
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
                                 
                                  if (!orderForm.isValidForm()) return;
                                  if (order!.isNewOrder && order!.tempId == "") {
                                    order?.id = '';
                                    order!.tempId = '${ client.id }-${ client.orders!.length + 1 }';
                                    if (!hasType) {
                                      order?.orderType = 'contado';
                                    }
                                    if (!hasStatus) {
                                      order?.orderStatus = 'pedido';
                                    }
                                    order!.isNewOrder = false;
                                    client.orders!.add(order!);
                                  }
                                  if (order?.orderStatus == 'cancelado') {
                                    val = await _showDialog(context);
                                    if (val) {
                                      order?.total = 0;
                                      client.balance = client.orders!.map((item) => item.total).reduce((value, current) => value + current); // .reduce((value, element) => (value.total + element.total)) as double;
                                      // ignore: use_build_context_synchronously
                                      saveOrUpdate(context, clientService, client);
                                    }
                                  } else {
                                     client.balance = client.orders!.map((item) => item.total).reduce((value, current) => value + current); // .reduce((value, element) => (value.total + element.total)) as double;
                                     saveOrUpdate(context, clientService, client);
                                  }
                                  
                                }),
                          ))
                        ],
                      ),
                    )),
              )
            ]));
  }

}

void saveOrUpdate(BuildContext context,ClientsService clientService, Client client) async {
  client.id.contains('*') ? 
        await clientService.save(client, false) :
        await clientService.update(client);
        // ignore: use_build_context_synchronously
        Navigator.popAndPushNamed(context, 'clientDetail', arguments: client);
}


Future<bool> _showDialog(BuildContext context) async {
  return await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        elevation: 6,
        title: const Text('title'),
        content: const Text('message'),
        actions: [
              MaterialButton(
                onPressed: () { 
                  Navigator.pop(context, false);
                  },
                child: const Text('Cancelar'),
              ),
              MaterialButton(
                textColor: Colors.redAccent,
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: const Text('Continuar'),
              ),
          ]
      );
    });
}
