import 'package:flutter/material.dart';
import 'package:vianey_payments/models/models.dart';
import 'package:vianey_payments/controls/input_control.dart';

class OrderDetailScreen extends StatelessWidget {

  const OrderDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final clientCustom = ModalRoute.of(context)!.settings.arguments as ClientCustom;
    Client client = clientCustom.client as Client;
    String id = clientCustom.id ?? '';
    final title = id.contains('*') ? 'Agregar orden a: ' : 'Acualizar orden a:';
    final titleBtn = id.contains('*') ? 'Agregar: ' : 'Acualizar';
    final order = id.contains('*') ? Order(orderDate: '', orderStatus: '', total: 0, comment: '', isExpanded: false) : client.orders!.isNotEmpty ? client.orders?.where((element) => element.id == id).first : null;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar orden')
      ),
      
      
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        children: [ Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
          child: Form(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(                
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                            // ignore: prefer_interpolation_to_compose_strings
                            title: Row(mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[Text(title + client.name,
                            style: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 20.0),)
                              ],),
                            ),
                            TextFormField(  
                              // ignore: unrelated_type_equality_checks
                              initialValue: order != 0 ? order?.orderDate : null,
                              autocorrect: false,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputControl.authInputDecoration(
                                hintText: 'Fecha',
                                labelText: 'Fecha',
                                prefixIcon: Icons.date_range_outlined
                              ),
                          ), 
                          const SizedBox( height: 10 ),
                          TextFormField(  
                            // ignore: unrelated_type_equality_checks
                            initialValue: order != 0 ? order?.comment : null,
                            autocorrect: false,
                            keyboardType: TextInputType.text,
                            decoration: InputControl.authInputDecoration(
                              hintText: 'Comentario',
                              labelText: 'Comentario',
                              prefixIcon: Icons.comment
                            ) 
                          ),
                          const SizedBox( height: 10 ),
                          TextFormField(  
                            // ignore: unrelated_type_equality_checks
                            initialValue: order != 0 && order != null ? '\$ 100' : null, // '\$ ' + order! != 0 ? '' : '' , // order?.products.map((e) => e.price).reduce((value, element) => value + element).toStringAsFixed(2),
                            autocorrect: false,
                            enabled: false,
                            keyboardType: TextInputType.text,
                            decoration: InputControl.authInputDecoration(
                              hintText: 'Total',
                              labelText: 'Total de está orden',
                              prefixIcon: Icons.monetization_on
                            ) 
                          ),
                const SizedBox( height: 10 ),
                  Center(  
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        disabledColor: Colors.grey,
                        elevation: 0,
                        color: const Color.fromRGBO(118, 35, 109, 1),
                        child: Container(
                          padding: const EdgeInsets.symmetric( horizontal: 80, vertical: 15),
                          child: Text(
                            titleBtn,
                            style: const TextStyle( color: Colors.white ),
                          )
                        ),
                        onPressed: () {}
                      ),
                    )
                  )
                ],
              ),
            )
          ),
        )
        ]
      )
    );
  }
}