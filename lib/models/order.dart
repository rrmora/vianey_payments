import 'dart:convert';

class Order {
  Order(
      {this.id,
      required this.orderDate,
      required this.orderStatus,
      required this.orderType,
      required this.total,
      required this.comment,
      required this.isExpanded});

  String? id;
  String orderDate;
  String orderStatus;
  String orderType;
  double total;
  String comment;
  bool isExpanded = false;

  factory Order.fromJson(String str) => Order.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Order.fromMap(Map<String, dynamic> json) => Order(
      orderDate: json["order_date"],
      orderStatus: json["order_status"],
      orderType: json["order_type"],
      total: json["total"].toDouble(),
      comment: json["comment"],
      isExpanded: false);

  Map<String, dynamic> toMap() => {
        "orderDate": orderDate,
        "orderStatus": orderStatus,
        "comment": comment,
        "total": total
      };

  Order copy() => Order(
      id: id,
      orderDate: orderDate,
      orderStatus: orderStatus,
      orderType: orderType,
      total: total,
      comment: comment,
      isExpanded: false);
}
