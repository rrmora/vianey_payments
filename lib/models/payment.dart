import 'dart:convert';

class Payment {
  Payment(
      {this.id,
      required this.tempId,
      required this.isNewPayment,
      required this.paymentDate,
      required this.amountPayment,
      required this.balance});

  String? id;
  String tempId;
  bool isNewPayment = true;
  String paymentDate;
  double amountPayment;
  double balance;

  // factory Payment.fromJson(String str) => Payment.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        paymentDate: json["payment_date"],
        tempId: json["temp_id"],
        isNewPayment: json["is_new_payment"],
        amountPayment: json["amount_payment"].toDouble(),
        balance: json["balance"].toDouble(),
      );

  Map<String, dynamic> toMap() => {
        "payment_date": paymentDate,
        "amount_payment": amountPayment,
        "temp_id": tempId,
        "is_new_payment": isNewPayment,
        "balance": balance,
      };

  Payment copy() => Payment(
        paymentDate: paymentDate,
        amountPayment: amountPayment,
        balance: balance,
        tempId: tempId,
        isNewPayment: isNewPayment,
        id: id,
      );
}
