import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vianey_payments/models/models.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ClientsService extends ChangeNotifier {
  final storage = const FlutterSecureStorage();

  final String _baseUrl = 'pagos-vianey-default-rtdb.firebaseio.com';
  List<Client> clients = [];
  Client? selectedClient;

  bool isLoading = true;
  bool isSaving = false;

  ClientsService() {
    loadClients();
  }

  Future<List<Client>?> loadClients() async {
    isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, 'clients.json',
        {'auth': await storage.read(key: 'token') ?? ''});
    final resp = await http.get(url);

    final Map<String, dynamic> clientsMap = json.decode(resp.body) == null ? {} : json.decode(resp.body);
    clientsMap.forEach((key, value) {
      final tempClient = Client.fromMap(value);
      tempClient.id = key;
      clients.add(tempClient);
    });

    isLoading = false;
    notifyListeners();
    clients.sort((a, b) => b.created.compareTo(a.created));
    return clients;
  }

  Future save(Client client, bool isNewClient) async {
    
    client.orders = [];
    client.payments = [];
    final url = Uri.https( _baseUrl, 'clients.json', {
      'auth': await storage.read(key: 'token') ?? ''
    });
    isSaving = true;
    final response = await http.post(url, body: client.toJson());

    final decodedData = json.decode(response.body);

    print(decodedData);
    clients = [];
    loadClients();
    notifyListeners();
    isSaving = false;
    if ( response.statusCode != 200 && response.statusCode != 201 ) {
      print('algo salio mal');
      print( response.body );
      return null;
    }
  }

  Future update(Client client) async {
    final url = Uri.https( _baseUrl, 'clients/${ client.id }.json', {
      'auth': await storage.read(key: 'token') ?? ''
    });
    isSaving = true;
    final response = await http.put(url, body: client.toJson());

    json.decode(response.body);
    // loadClients();
    notifyListeners();
    isSaving = false;
    if ( response.statusCode != 200 && response.statusCode != 201 ) {
      print('algo salio mal');
      print( response.body );
      return null;
    }
  }
}
