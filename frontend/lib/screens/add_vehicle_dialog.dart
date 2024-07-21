import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/vehicle_service.dart';

class AddVehicleDialog extends StatefulWidget {
  @override
  _AddVehicleDialogState createState() => _AddVehicleDialogState();
}

class _AddVehicleDialogState extends State<AddVehicleDialog> {
  final TextEditingController _nameController = TextEditingController();
  String _selectedSize = 'Small'; // Default value
  final List<String> _sizes = ['Small', 'Medium', 'Large']; // List of sizes

  @override
  Widget build(BuildContext context) {
    final vehicleService = Provider.of<VehicleService>(context, listen: false);

    return AlertDialog(
      title: Text('Add Vehicle'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Name'),
          ),
          DropdownButton<String>(
            value: _selectedSize,
            onChanged: (String? newValue) {
              setState(() {
                _selectedSize = newValue!;
              });
            },
            items: _sizes.map<DropdownMenuItem<String>>((String size) {
              return DropdownMenuItem<String>(
                value: size,
                child: Text(size),
              );
            }).toList(),
          ),
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
            final name = _nameController.text;
            await vehicleService.addVehicle(name, _selectedSize);
            Navigator.of(context).pop();
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}
