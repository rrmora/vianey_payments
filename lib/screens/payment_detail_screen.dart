import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../controls/input_control.dart';
import '../models/models.dart';
import '../providers/payment_form_provider.dart';
import '../services/services.dart';

class PaymentDetailScreen extends StatelessWidget {
  const PaymentDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final clientsService = Provider.of<ClientsService>(context);
    final clientCustom = ModalRoute.of(context)!.settings.arguments as ClientCustom;
    Client client = clientCustom.client as Client;
    String id = clientCustom.id ?? '*';
    final payment = id.contains('*') 
      ? Payment(
              tempId: '',
              isNewPayment: true,
              paymentDate: '',
              amountPayment: 0,
              balance: 0
       ) : client.payments!.isNotEmpty
       ? client.payments!.where((element) => element.tempId == id).first : null ;
    final paymentTemp = payment!.copy();
    var title = 'Agregar pago a: ';
    var titleBtn = 'Agregar';
    final createUpdate = id.contains('*') ? true : false;
    if (!payment.isNewPayment) {
      title = 'Acualizar pago a:';
      titleBtn = 'Acualizar';
    }
    payment.balance = client.balance;

    return ChangeNotifierProvider(
        create: (_) => PaymentFormProvider(payment),
        child: _PaymentScreenState(
          client: client,
          clientService: clientsService,
          payment: payment,
          paymentTemp: paymentTemp,
          title: title,
          titleBtn: titleBtn,
          createUpdate: createUpdate
        )
    );
  }
}

class _PaymentScreenState extends StatelessWidget {
 const _PaymentScreenState({Key? key,
      required this.client,
      required this.clientService,
      required this.payment,
      required this.paymentTemp,
      required this.title,
      required this.titleBtn,
      required this.createUpdate
 }) : super(key: key);

  final Client client;
  final ClientsService clientService;
  final Payment? payment;
  final Payment? paymentTemp;
  final String title;
  final String titleBtn;
  final bool createUpdate;

  @override
  Widget build(BuildContext context) {
    final formatter  = NumberFormat.currency(locale: 'es_MX', decimalDigits: 2, name: '');
    final paymentForm = Provider.of<PaymentFormProvider>(context);
    final paymentF = paymentForm.payment;
    var now = DateTime.now();
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => { 
              if (client.payments!.isNotEmpty && paymentTemp!.tempId != "") {
                client.payments![client.payments!.indexWhere((element) => element.tempId == paymentTemp!.tempId)] = paymentTemp!
              },
              Navigator.popAndPushNamed(context, 'clientDetail', arguments: client)
            },
          ),
         title: const Text('Agregar pago')),
        body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            children: [
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0)),
                child: Form(
                    key: paymentForm.formKey,
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
                            initialValue: payment?.paymentDate != ""
                                ? payment?.paymentDate
                                : (payment?.paymentDate =
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
                              initialValue:
                                  '\$${payment?.amountPayment ?? (payment?.amountPayment = 0)}',
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
                                      {paymentF?.amountPayment = 0}
                                    else {
                                        paymentF?.amountPayment = double.parse(value)
                                      }
                                  },
                              // ignore: body_might_complete_normally_nullable
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Abono es obligatorio';
                                }
                                value = value.replaceFirst("\$", '');
                                value = value.replaceAll(",", '');
                                if (double.parse(value) > payment!.balance) {
                                  return 'Abono debe ser menor o igual al balance';
                                }
                              },
                              decoration: InputControl.authInputDecoration(
                                  hintText: 'Abono',
                                  labelText: 'Abono',
                                  prefixIcon: Icons.monetization_on)),
                          const SizedBox(height: 10),
                          TextFormField(
                              // ignore: unrelated_type_equality_checks
                              initialValue:
                                  '\$${payment?.balance ?? (formatter.format(payment?.balance = 0))}',
                              // enabled: false,
                              keyboardType: TextInputType.number,
                              enabled: false,
                              inputFormatters: [
                                //FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))
                                CurrencyTextInputFormatter(
                                    decimalDigits: 2, symbol: '\$')
                              ],
                              onChanged: (value) => {
                                    value = value.replaceFirst("\$", ''),
                                    if (double.tryParse(value) == null)
                                      {paymentF?.balance = 0}
                                    else
                                      {paymentF?.balance = double.parse(value)}
                                  },
                              // ignore: body_might_complete_normally_nullable
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Balance es obligatorio';
                                }
                              },
                              decoration: InputControl.authInputDecoration(
                                  hintText: 'Balance',
                                  labelText: 'Balance',
                                  prefixIcon: Icons.monetization_on)),
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
                                  if (!paymentForm.isValidForm()) return;

                                  if (payment!.isNewPayment && payment!.tempId == "") {
                                    payment?.id = '';
                                    payment?.tempId = '${client.id}-${client.payments!.length + 1}';

                                    client.balance = (client.balance - payment!.amountPayment);
                                    payment!.balance = client.balance;
                                    payment!.isNewPayment = false;
                                    client.payments!.add(payment!);
                                  } else {
                                    if (payment!.amountPayment != paymentTemp!.amountPayment) {
                                      client.balance = (client.balance - payment!.amountPayment);
                                      payment!.balance = client.balance;
                                    }
                                  }
                                  client.id.contains('*')
                                      ? await clientService.save(client, false)
                                      : await clientService.update(client);
                                  // ignore: use_build_context_synchronously
                                  Navigator.popAndPushNamed(context, 'clientDetail',
                                      arguments: client);
                                }),
                          ))
                        ],
                      ),
                    )),
              )
            ]));
  }

}