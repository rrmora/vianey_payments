import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vianey_payments/models/models.dart';
import 'package:vianey_payments/widgets/widgets.dart';

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
    client.orders = client.orders ?? (client.orders = []);
    client.payments = client.payments ?? (client.payments = []);
    return Scaffold(
      appBar: AppBar(
          title: Text('${client.name} - Balance: \$${ formatter.format(client.balance) }')), // client.balance.toStringAsFixed(2)}')),
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
        visible: !(_currentIndex == 1 && client.orders.length == 0),
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
}
