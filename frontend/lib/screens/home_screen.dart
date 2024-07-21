import 'package:flutter/material.dart';
import 'package:frontend/screens/order_screen.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/vehicle_service.dart';
import '../services/booking_service.dart';
import 'add_vehicle_dialog.dart';
import 'booking_dialog.dart';
import 'pricing_screen.dart';
import 'user_details_screen.dart'; // Ensure this file is created

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<void> _futureVehicles;
  int selected_item=0;
  @override
  void initState() {
    super.initState();
    _futureVehicles = Provider.of<VehicleService>(context, listen: false).getVehicles();
    Provider.of<AuthService>(context, listen: false).getdetail();
  }
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selected_item,
        onTap: (item){
           setState(() {
             selected_item=item;
           });
        },
        items: [
           BottomNavigationBarItem(
               label: "Home",
               icon: IconButton(
             onPressed: (){

             },
             icon: Icon(Icons.home),
           )),
          BottomNavigationBarItem(
              label: 'Orders',
              icon: IconButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OrderScreen()),
                  );
                },
                icon: Icon(Icons.list_alt),
              )),
          BottomNavigationBarItem(
              label: 'Profile',
              icon: IconButton(
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserDetailsScreen()),
              );
            },
            icon: Icon(Icons.account_circle),
          ))
        ],
      ),
      appBar: AppBar(
        title: Text('Home'),
        actions: [

          Text('\$'+context.watch<AuthService>().wallet),
          SizedBox( width: 10,),
          IconButton(
            icon: Icon(Icons.menu_book),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PricingScreen()),
              );
            },
          ),
        ],

      ),
      body: FutureBuilder<void>(
        future: _futureVehicles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return Consumer<VehicleService>(
            builder: (context, vehicleService, _) {
              if (vehicleService.vehicles.isEmpty) {
                return Center(child: Text('No vehicles available'));
              }

              return ListView.builder(
                itemCount: vehicleService.vehicles.length,
                itemBuilder: (context, index) {
                  final vehicle = vehicleService.vehicles[index];
                  return ListTile(
                    title: Text(vehicle['name']),
                    subtitle: Text(vehicle['size']),
                    trailing: SizedBox(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Delete Button
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () async {
                              final bool confirmDelete = await showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Delete Vehicle'),
                                  content: Text('Are you sure you want to delete this vehicle?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(false),
                                      child: Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: (){
                                        Navigator.of(context).pop(true);

                                      },
                                      child: Text('Delete'),
                                    ),
                                  ],
                                ),
                              );

                              if (confirmDelete) {
                                try {
                                  print(vehicle['_id']);
                                  bool success=await vehicleService.deletevehicle(vehicle['_id']);
                                  if(success)
                                   ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Vehicle deleted successfully')),
                                    );
                                   else{
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Vehicle deleted successfully')),
                                    );
                                  }
                                  // Refresh the vehicle list
                                  setState(() {
                                    _futureVehicles = vehicleService.getVehicles();
                                  });
                                } catch (error) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Failed to delete vehicle')),
                                  );
                                }
                              }
                            },
                          ),
                          // Book Wash Button
                          ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => BookingDialog(vehicle: vehicle),
                              );
                            },
                            child: Text('Book Wash'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: context.watch<VehicleService>().vehicles.length<9?() {
          showDialog(
            context: context,
            builder: (context) => AddVehicleDialog(),
          );
        }:null,
        child: Icon(Icons.add),
      ),
    );
  }
}
