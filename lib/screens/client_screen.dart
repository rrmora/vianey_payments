import 'package:flutter/material.dart';
import 'package:vianey_payments/controls/input_control.dart';
import 'package:vianey_payments/models/clients.dart';

class ClientScreen extends StatefulWidget {
  const ClientScreen({Key? key}) : super(key: key);

  @override
  State<ClientScreen> createState() => _ClientScreenState();
}

class _ClientScreenState extends State<ClientScreen> {
  @override
  Widget build(BuildContext context) {
    final client = ModalRoute.of(context)!.settings.arguments as Client;
    final titleHeader = client.id.contains('*') ? 'Agregar cliente' : 'Actualizar cliente';
    final titleBtn = client.id.contains('*') ? 'Agregar' : 'Actualizar';
    return Scaffold(
      appBar: AppBar(
        title: Text(titleHeader),
        // actions: [IconButton(
        //   icon: const Icon(Icons.arrow_back),
        //   onPressed: () {
        //     Navigator.popAndPushNamed(context, 'clientsList');
        //   })],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 50),
        children: [ Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
          child: Form(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(                
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                  title: Row(mainAxisAlignment: MainAxisAlignment.center,children: const <Widget>[Text('Información Personal',
                  style: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 25.0),)
                    ],),
                  ),
                  TextFormField(  
                    initialValue: client.name,
                    autocorrect: false,
                    keyboardType: TextInputType.name,
                    decoration: InputControl.authInputDecoration(
                      hintText: 'Nombre',
                      labelText: 'Nombre',
                      prefixIcon: Icons.person
                    ),
              // onChanged: ( value ) => loginForm.email = value,
              // validator: ( value ) {

              //     String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
              //     RegExp regExp  = new RegExp(pattern);
                  
              //     return regExp.hasMatch(value ?? '')
              //       ? null
              //       : 'El valor ingresado no luce como un correo';

              // },
            
                  // decoration: const InputDecoration(  
                  //   focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.indigo)),
                  //   labelStyle:   TextStyle(color: Colors.black87),
                  //   icon: const Icon(Icons.person, color: Colors.indigo),  
                  //   hintText: 'Nombre',  
                  //   labelText: 'Nombre',  
                  // ),  
                ), 
                const SizedBox( height: 10 ),
                TextFormField(  
                  initialValue: client.lastname,
                  autocorrect: false,
                  keyboardType: TextInputType.text,
                  decoration: InputControl.authInputDecoration(
                    hintText: 'Apellido',
                    labelText: 'Apellido',
                    prefixIcon: Icons.person
                  ),
                  // decoration: const InputDecoration(  
                  //   focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.indigo)),
                  //   labelStyle:   TextStyle(color: Colors.black87),
                  //   icon: const Icon(Icons.person, color: Colors.indigo),  
                  //   hintText: 'Apellido',  
                  //   labelText: 'Apellido',  
                  // ),  
                ),
                const SizedBox( height: 10 ),
                TextFormField(  
                  initialValue: client.address,
                  autocorrect: false,
                  keyboardType: TextInputType.text,
                  decoration: InputControl.authInputDecoration(
                    hintText: 'Dirección',
                    labelText: 'Dirección',
                    prefixIcon: Icons.home
                  ),
                  // decoration: const InputDecoration(  
                  //   focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.indigo)),
                  //   labelStyle:   TextStyle(color: Colors.black87),
                  //   icon: const Icon(Icons.home, color: Colors.indigo),   
                  //   hintText: 'Dirección',  
                  //   labelText: 'Dirección',  
                  // ),  
                ),
                const SizedBox( height: 10 ),
                TextFormField(  
                  initialValue: client.phone,
                  autocorrect: false,
                  keyboardType: TextInputType.phone,
                  decoration: InputControl.authInputDecoration(
                    hintText: 'Teléfono',
                    labelText: 'Teléfono',
                    prefixIcon: Icons.phone
                  ),
                  // decoration: const InputDecoration(  
                  //   focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.indigo)),
                  //   labelStyle:   TextStyle(color: Colors.black87),
                  //   icon: const Icon(Icons.phone, color: Colors.indigo),  
                  //   hintText: 'Teléfono',  
                  //   labelText: 'Teléfono',  
                  // ),  
                ), 
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