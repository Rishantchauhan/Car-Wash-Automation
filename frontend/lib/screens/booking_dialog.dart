import 'package:flutter/material.dart';
import 'package:frontend/screens/pricing_screen.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:provider/provider.dart';
import '../services/booking_service.dart';

// Ensure this file is created

class BookingDialog extends StatefulWidget {
  final dynamic vehicle;

  BookingDialog({required this.vehicle});

  @override
  _BookingDialogState createState() => _BookingDialogState();
}

class _BookingDialogState extends State<BookingDialog> {
  String _selectedWashQuality = 'Standard';
  double _totalPrice = 0.0;

  void _updateTotalPrice() {
    final pricing = pricingList.firstWhere((p) => p.washQuality == _selectedWashQuality);
    setState(() {
      _totalPrice = pricing.prices[widget.vehicle['size']] ?? 0.0;
    });
  }

  @override
  void initState() {
    super.initState();
    _updateTotalPrice();
  }

  void _showAlertDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Book Wash for ${widget.vehicle['name']}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButton<String>(
            value: _selectedWashQuality,
            onChanged: (String? newValue) {
              setState(() {
                _selectedWashQuality = newValue!;
                _updateTotalPrice();
              });
            },
            items: pricingList.map<DropdownMenuItem<String>>((Pricing pricing) {
              return DropdownMenuItem<String>(
                value: pricing.washQuality,
                child: Text(pricing.washQuality),
              );
            }).toList(),
          ),
          Text('Price: \$${_totalPrice.toStringAsFixed(2)}'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            final bookingService = Provider.of<BookingService>(context, listen: false);
            final result = await bookingService.bookWash(widget.vehicle['_id'], _selectedWashQuality, _totalPrice, widget.vehicle['name']);
            print(result);
            if (result == "Booking Success") {
              bool succ = await Provider.of<AuthService>(context, listen: false).getdetail();
              if (succ) {
                _showAlertDialog('Success', 'Wash booked successfully');
                Navigator.of(context).pop();
              }
            } else {
              _showAlertDialog('Failure', 'Booking failed');
            }
          },
          child: Text('Book'),
        ),
      ],
    );
  }
}
