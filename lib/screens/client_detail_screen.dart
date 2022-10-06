import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vianey_payments/models/models.dart';
import 'package:vianey_payments/widgets/widgets.dart';

import 'client_list_screen.dart';

class ClientDetailScreen extends StatefulWidget {
  const ClientDetailScreen({Key? key}) : super(key: key);

  @override
  State<ClientDetailScreen> createState() => _ClientDetailScreenState();
}

class _ClientDetailScreenState extends State<ClientDetailScreen> {
  final formatter  = NumberFormat.currency(locale: 'es_MX', decimalDigits: 2, name: '');
  final ClientCustom clientCustom = ClientCustom();
  final PageController _pageController = PageController(initialPage: 0);
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final client = ModalRoute.of(context)!.settings.arguments as Client;
    final clientAux = ClientReset();
    client.orders = client.orders ?? (client.orders = []);
    client.payments = client.payments ?? (client.payments = []);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => { 
              clientAux.reset = false,
              Navigator.popAndPushNamed(context, 'clientsList', arguments: clientAux)
            },
          ),
          title: Row(  
          mainAxisAlignment: MainAxisAlignment.start,  
          children:<Widget>[   
            Container(  
              margin: const EdgeInsets.all(1.0),  
              padding: const EdgeInsets.all(1.0),  
              child: Text(_cutString(client.name, 10) ,style: const TextStyle(fontSize: 20.0)),  
            ),  
            Container(  
              margin: const EdgeInsets.only(left: 10.0, top: 2.0),  
              padding: const EdgeInsets.all(2.0),   
              child: const Text("Balance",style: TextStyle(fontSize: 18.0)),  
            ),
            Container(  
              margin: const EdgeInsets.only(left: 1.0, top: 2.0),  
              padding: const EdgeInsets.all(2.0),  
              child:  Text('\$${ formatter.format(client.balance) }', style: const TextStyle(fontSize: 18.0, color:Color.fromARGB(255, 235, 61, 48))),  
            )
          ]  
      ),  
          // title: Text('${client.name} - Balance: \$${ formatter.format(client.balance) }')
      ), // client.balance.toStringAsFixed(2)}')),
      body: _pageViewWidget(client),
      floatingActionButton: _floatingActionButton(client),
      bottomNavigationBar: _bottomNavigation(),
    );
  }

  _pageViewWidget(client) {
    final res = client;
    clientCustom.client = res;
    clientCustom.id = '*';
    return PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          OrderList(client: client),
          PaymentsList(client: client, clientCustom: clientCustom),
        ]);
  }

  _floatingActionButton(client) {
    return Visibility(
        visible: !(_currentIndex == 1 && (client.orders.length == 0 || client.balance == 0)),
        child: FloatingActionButton(
          onPressed: () => {
            if (_currentIndex == 0)
              {
                Navigator.popAndPushNamed(context, 'orderDetail',
                    arguments: clientCustom)
              }
            else
              {
                Navigator.popAndPushNamed(context, 'paymentDetail',
                    arguments: clientCustom)
              }
          },
          child: const Icon(Icons.add),
        ));
  }

  _bottomNavigation() {
    return BottomNavigationBar(
        backgroundColor: const Color.fromRGBO(118, 35, 109, 1),
        currentIndex: _currentIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        selectedFontSize: 15,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.production_quantity_limits_outlined, size: 28),
            label: 'Pedidos',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.price_check_outlined, size: 28), label: 'Pagos')
        ],
        onTap: (index) {
          _pageController.animateToPage(index,
              duration: const Duration(milliseconds: 500), curve: Curves.ease);
        });
  }

  _cutString(String value, int length) {
    var res = value.length < 11 ? value : '${value.substring(0, length)}...';
    return res;
  }
}
