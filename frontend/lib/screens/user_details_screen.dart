import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class UserDetailsScreen extends StatelessWidget {
  const UserDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Fetch user details from AuthService
    final authService = context.watch<AuthService>();

    // Check if the user details are available
    if (authService.name.isEmpty) {
      // If user details are not loaded, show a loading indicator
      return Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserDetailsItem(
              label: 'Name',
              value: authService.name,
              ic: Icon(Icons.person),
            ),
            SizedBox(height: 10),
            UserDetailsItem(
              label: 'Email',
              value: authService.email,
              ic: Icon(Icons.email),
            ),
            SizedBox(height: 10),
            UserDetailsItem(
              label: 'Wallet Balance',
              value: '\$${authService.wallet}',
              ic: Icon(Icons.wallet),
            ),
            Center(
              child: ElevatedButton(
                child: Text('Log Out'),
                onPressed: () {
                  // Call logout method from AuthService
                  authService.logout();
                  // Navigate to login screen
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserDetailsItem extends StatelessWidget {
  final String label;
  final String value;
  final Icon ic;

  UserDetailsItem({
    required this.ic,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ic,
      title: Text(label),
      subtitle: Text(value),
    );
  }
}
