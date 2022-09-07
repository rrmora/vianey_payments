import 'package:flutter/material.dart';
import 'package:vianey_payments/models/models.dart';
import 'package:vianey_payments/widgets/widgets.dart';

class OrderList extends StatefulWidget {
  final Client client;
  const OrderList({Key? key, required this.client}) : super(key: key);

  @override
  State<OrderList> createState() => _OrdersListState();
}

class _OrdersListState extends State<OrderList> {
  final ClientCustom clientCustom = ClientCustom();
  @override
  Widget build(BuildContext context) {
    var order = widget.client.orders;
    if (!(order!.isNotEmpty)) {
      order = [];
    }
    return SingleChildScrollView(
      child: (order.isNotEmpty) ? _orderList() : const CardNoContent(),
    );
  }

  _orderList() {
    return Padding(
      padding: const EdgeInsets.all(7.0),
      child: ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            widget.client.orders![index].isExpanded = !isExpanded;
          });
        },
        children: widget.client.orders!.map<ExpansionPanel>((Order item) {
          return ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return const ListTile(
                title: Text('Total: \$0.00',
                    style:
                        TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              );
            },
            body: Stack(children: [
              ListTile(
                  title: Text('Fecha: ${item.orderDate}',
                      style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 15,
                          fontWeight: FontWeight.bold)),
                  subtitle: Text('Comentario: ${item.comment}',
                      style:
                          const TextStyle(color: Colors.black54, fontSize: 15)),
                  trailing: const Icon(Icons.edit, size: 30),
                  onTap: () {
                    setState(() {
                      // ignore: avoid_print
                      print(item);
                      final res = widget.client;
                      clientCustom.client = res;
                      clientCustom.id = item.id;
                      Navigator.popAndPushNamed(context, 'orderDetail',
                          arguments: clientCustom);
                    });
                  })
            ]),
            isExpanded: item.isExpanded,
          );
        }).toList(),
      ),
    );
  }
}
