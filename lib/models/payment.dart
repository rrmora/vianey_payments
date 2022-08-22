import 'dart:convert';

class Payment {
    Payment({
        this.id,
        required this.paymentDate,
        required this.amountPayment,
        required this.balance
    });

    String? id;
    String paymentDate;
    double amountPayment;
    double balance;

    factory Payment.fromJson(String str) => Payment.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Payment.fromMap(Map<String, dynamic> json) => Payment(
        paymentDate: json["payment_date"],
        amountPayment: json["amount_payment"].toDouble(),
        balance: json["balance"].toDouble(),
    );

    Map<String, dynamic> toMap() => {
        "paymentDate": paymentDate,
        "amountPayment": amountPayment,
        "balance": balance,
    };

    Payment copy() => Payment(
      paymentDate: paymentDate,
      amountPayment: amountPayment,
      balance: balance,
      id: id,
    );

}