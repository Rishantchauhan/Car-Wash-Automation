import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/booking_service.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  void initState() {
    super.initState();
    // Call getBooking directly in initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookingService>().getBooking();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.list_alt_rounded),
        title: Text('Orders'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Consumer<AuthService>(
                builder: (context, userService, _) => Text(
                  '\$${userService.wallet}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: context.watch<BookingService>().Orders.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Text(context.watch<BookingService>().Orders[index]['vehicle'].toString()),
            title: Text('Wash Quality: ' + context.watch<BookingService>().Orders[index]['washQuality'].toString()),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Price: \$' + context.watch<BookingService>().Orders[index]['price'].toString(),style: TextStyle(color: Colors.red),),
                Text('Date: ' + context.watch<BookingService>().Orders[index]['date']),
              ],
            ),
          );
        },
      ),
    );
  }
}
