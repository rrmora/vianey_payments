import 'dart:convert';

import 'package:vianey_payments/models/models.dart';

class Client {
  String id;
  String name;
  String lastname;
  String? address;
  double balance;
  String phone;
  String status;
  DateTime created;
  List<Payment>? payments;
  List<Order>? orders;

  Client(
      {required this.id,
      required this.name,
      required this.lastname,
      this.address,
      required this.balance,
      required this.phone,
      required this.status,
      required this.created,
      this.payments,
      this.orders});

  String toJson() => json.encode(toMap());

  factory Client.fromJson(dynamic json) {
    final paymentList = json['payments'] as List;
    List<Payment> payments =
        paymentList.isNotEmpty ?
        paymentList.map((i) => Payment.fromJson(i)).toList() : [];
    final orderList = json['orders'] as List;
    List<Order> orders = 
      orderList.isNotEmpty ?
      orderList.map((i) => Order.fromJson(i)).toList() : [];

    return Client(
      id: json['id'] as String,
      name: json['name'] as String,
      lastname: json['lastname'] as String,
      address: json['address'],
      balance: json['balance'].toDouble(),
      phone: json['phone'],
      status: json['status'],
      created: json['created'],
      payments: payments,
      orders: orders,
    );
  }

  Map<String, dynamic> toMap() => {
        "name": name,
        "lastname": lastname,
        "balance": balance,
        "address": address,
        "phone": phone,
        "status": status,
        "created": created.toUtc().millisecondsSinceEpoch,
        'payments': payments?.map((payment) => payment.toMap()).toList(growable: false),
        'orders': orders?.map((order) => order.toMap()).toList(growable: true),
      };

  static Client fromMap(Map<String, dynamic> map) {
    return Client(
        id: map.containsKey('id') ? map['id'] : '*',
        name: map['name'],
        lastname: map['lastname'],
        balance: map['balance'].toDouble(),
        address: map['address'],
        phone: map['phone'].toString(),
        status: map['status'],
        created: DateTime.fromMillisecondsSinceEpoch(map['created']),
        payments:
            map.containsKey('payments') ? List<Payment>.from(map['payments'].map((p) => Payment.fromJson(p))) : [],
        orders: map.containsKey('orders') ? List<Order>.from(map['orders'].map((o) => Order.fromJson(o))) : []);// orderList(map['orders']) : []);
  }

  Client copy() => Client(
        id: id,
        name: name,
        lastname: lastname,
        balance: balance,
        address: address,
        phone: phone,
        status: status,
        created: created,
        payments: payments,
        orders: orders,
      );
}
