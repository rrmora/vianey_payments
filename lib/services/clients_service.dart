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

    final url = Uri.https(_baseUrl, 'clients.json',
        {'auth': await storage.read(key: 'token') ?? ''});
    final resp = await http.get(url);

    final Map<String, dynamic> clientsMap = json.decode(resp.body);
    print(clientsMap);
    clientsMap.forEach((key, value) {
      final tempClient = Client.fromMap(value);
      tempClient.id = key;
      clients.add(tempClient);
    });

    isLoading = false;
    notifyListeners();

    return clients;
  }

  Future save(Client client, bool isNewClient) async {
    
    client.orders = [];
    client.payments = [];
    final url = Uri.https( _baseUrl, 'clients.json', {
      'auth': await storage.read(key: 'token') ?? ''
    });
    isSaving = true;
    final clientJ = client.toJson();
    print(clientJ);
    final response = await http.post(url, body: clientJ);

    final decodedData = json.decode(response.body);

    print(decodedData);
    // loadClients();
    // notifyListeners();
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
    // client.orders = client.orders!.map((r) => r.toJson() ).cast<Order>().toList();
    print(json.encode(client.toJson()));
    final response = await http.put(url, body: client.toJson());

    json.decode(response.body);

    print(client.toJson());
    // loadClients();
    // notifyListeners();
    isSaving = false;
    if ( response.statusCode != 200 && response.statusCode != 201 ) {
      print('algo salio mal');
      print( response.body );
      return null;
    }
  }
}
