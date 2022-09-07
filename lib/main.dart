import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vianey_payments/screens/screens.dart';
import 'package:vianey_payments/services/services.dart';
import 'package:vianey_payments/services/notification_service.dart';

void main() {
  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        // ChangeNotifierProvider(create: ( _ ) => ProductsService() ),
        // ChangeNotifierProvider(create: ( _ ) => ClientFormProvider())
        ChangeNotifierProvider(create: (_) => ClientsService())
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vianey Pagos',
      initialRoute: 'login',
      routes: {
        // 'checkAuth'   : ( _ ) => CheckAuthScreen(),
        // 'dashboard'   : ( _ ) => DashboardScreen(),
        // 'home'    : ( _ ) => HomeScreen(),
        'login': (_) => const LoginScreen(),
        'client': (_) => const ClientScreen(),
        'clientsList': (_) => const ClientListScreen(),
        'clientDetail': (_) => const ClientDetailScreen(),
        'orderDetail': (_) => const OrderDetailScreen(),
        // 'paymentDetail' : ( _ ) => PaymentDetailScreen(),
        // 'product' : ( _ ) => ProductScreen(),
        // 'productDetail' : ( _ ) => ProductDetailScreen(),
        // 'register'   : ( _ ) => RegisterScreen(),
      },
      scaffoldMessengerKey: NotificationService.messengerKey,
      theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: Colors.grey[300],
          appBarTheme: const AppBarTheme(
              elevation: 0, color: Color.fromRGBO(118, 35, 109, 1)),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Color.fromRGBO(118, 35, 109, 1), elevation: 0)),
    );
  }
}
