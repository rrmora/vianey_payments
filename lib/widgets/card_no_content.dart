import 'package:flutter/material.dart';

class CardNoContent extends StatelessWidget {
  const CardNoContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 220),
      child: Center(child: _cardNoProducts()),
    );
  }

  _cardNoProducts() {
    return Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Form(
            child: Padding(
          padding: const EdgeInsets.all(50),
          child: Column(
            children: const [
              Icon(Icons.no_accounts, size: 100, color: Colors.indigo),
              SizedBox(height: 20),
              Text(
                'No hay información para mostrar',
                style: TextStyle(fontSize: 18, color: Colors.black87),
              )
            ],
          ),
        )));
  }
}
