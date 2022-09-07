import 'package:flutter/material.dart';

import '../models/models.dart';

class OrderFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Order? order;

  OrderFormProvider(this.order);

  bool isValidForm() {
    // ignore: avoid_print
    print(order);

    return formKey.currentState?.validate() ?? false;
  }
}
