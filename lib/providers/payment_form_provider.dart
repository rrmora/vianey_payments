import 'package:flutter/material.dart';

import '../models/models.dart';

class PaymentFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Payment? payment;

  PaymentFormProvider(this.payment);

  bool isValidForm() {
    // ignore: avoid_print
    print(payment);

    return formKey.currentState?.validate() ?? false;
  }
}
