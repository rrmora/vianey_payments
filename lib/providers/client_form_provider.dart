import 'package:flutter/material.dart';

import '../models/models.dart';

class ClientFormProvider extends ChangeNotifier {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    Client? client;

    ClientFormProvider( this.client );

    bool isValidForm() {
      // ignore: avoid_print
      print( client );

      return formKey.currentState?.validate() ?? false;
    }

}