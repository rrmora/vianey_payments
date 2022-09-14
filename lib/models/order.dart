import 'dart:convert';

class Order {
  Order(
      {this.id,
      required this.tempId,
      required this.orderDate,
      required this.orderStatus,
      required this.orderType,
      required this.total,
      required this.comment,
      required this.isExpanded,
      required this.isNewOrder});

  String? id;
  String tempId;
  String orderDate;
  String orderStatus;
  String orderType;
  double total;
  String comment;
  bool isExpanded = false;
  bool isNewOrder = true;

  // factory Order.fromJson(String str) => Order.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Order.fromJson(Map<String, dynamic> json) => Order(
      tempId: json["temp_id"],
      orderDate: json["order_date"],
      orderStatus: json["order_status"],
      orderType: json["order_type"],
      total: json["total"].toDouble(),
      comment: json["comment"],
      isExpanded: false,
      isNewOrder: json["is_new_order"]);

  Map<String, dynamic> toMap() => {
        "temp_id": tempId,
        "order_date": orderDate,
        "order_status": orderStatus,
        "order_type": orderType,
        "comment": comment,
        "is_new_order": isNewOrder,
        "total": total
      };

  Order copy() => Order(
      id: id,
      tempId: tempId,
      orderDate: orderDate,
      orderStatus: orderStatus,
      orderType: orderType,
      total: total,
      comment: comment,
      isExpanded: false,
      isNewOrder: isNewOrder);
}
