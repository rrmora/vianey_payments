import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vianey_payments/models/models.dart';
import 'package:vianey_payments/widgets/card_no_content.dart';


class PaymentsList extends StatelessWidget {
  final Client client;
  final ClientCustom clientCustom;
  const PaymentsList({Key? key, required this.client, required this.clientCustom}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: client.payments == null ? const CardNoContent() : _paymentListTable(context),
      );
  }
  
  _paymentListTable(BuildContext context) {
     final formatter  = NumberFormat.currency(locale: 'es_MX', decimalDigits: 2, name: '');
    return ListView(
          children: [ 
              Card(
                color: const Color.fromARGB(118, 35, 109, 100),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
                child: DataTable( 
                showCheckboxColumn: false,
                columnSpacing: 15.0,
                columns: const [
                  DataColumn(label: Text('Fecha', style: TextStyle(fontSize: 18))),
                  DataColumn(label: Text('Monto', style: TextStyle(fontSize: 18))),
                  DataColumn(label: Text('Balance', style: TextStyle(fontSize: 18))),
                ],
                rows: client.payments == null ? const <DataRow>[] :
                  client.payments!.map<DataRow>((e) => DataRow(
                    onSelectChanged: (b) {
                      clientCustom.client = client;
                      clientCustom.id = e.id;
                      Navigator.popAndPushNamed(context, 'paymentDetail', arguments: clientCustom);
                    },
                    cells: [
                      DataCell(Text(e.paymentDate, style: const TextStyle(fontSize: 16))),
                      DataCell(Text('\$${ formatter.format(e.amountPayment) }', style: const TextStyle(fontSize: 16))),
                      DataCell(Text('\$${ formatter.format(e.balance) }', style: const TextStyle(fontSize: 16))),
                    ]
                  )).toList()
                ),
              )
          ]
        );
  }
}
