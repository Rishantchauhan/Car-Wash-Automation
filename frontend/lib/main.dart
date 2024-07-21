import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'services/auth_service.dart';
import 'services/vehicle_service.dart';
import 'services/booking_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()..loadToken()),
        ChangeNotifierProvider(create: (context) => VehicleService()),
        ChangeNotifierProvider(create: (context) => BookingService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Car Wash App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: Consumer<AuthService>(
          builder: (context, authService, _) {
            if (authService.token != null) {
              return HomeScreen();
            } else {
              return LoginScreen();
            }
          },
        ),
        routes: {
          '/login': (context) => LoginScreen(),
          '/signup': (context) => SignUpScreen(),
          '/home': (context) => HomeScreen(),
        },
      ),
    );
  }
}
