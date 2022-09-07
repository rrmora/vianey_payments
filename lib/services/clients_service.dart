
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vianey_payments/models/models.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ClientsService extends ChangeNotifier {
  final storage = const FlutterSecureStorage();
  
  final String _baseUrl = 'pagos-vianey-default-rtdb.firebaseio.com';
  final List<Client> clients = [];
  Client? selectedClient;

   bool isLoading = true;
   bool isSaving = false;

  ClientsService() {
    loadClients();
  }

  Future<List<Client>> loadClients() async {

    isLoading = true;
    notifyListeners();

    final url = Uri.https( _baseUrl, 'clients.json', {
      'auth': await storage.read(key: 'token') ?? ''
    });
    final resp = await http.get( url );

    final Map<String, dynamic> clientsMap = json.decode( resp.body );

    clientsMap.forEach((key, value) {
      final tempClient = Client.fromMap( value );
      tempClient.id = key;
      clients.add( tempClient );
    });


    isLoading = false;
    notifyListeners();

    return clients;
  }

  Future save(Client client) async {
    isSaving = true;
    ChangeNotifier();
    print(client);
    isSaving = false;
    ChangeNotifier();
  }
}