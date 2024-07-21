import 'package:flutter/material.dart';

class PricingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pricing'),
      ),
      body: ListView(
        children: pricingList.map((pricing) {
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(pricing.washQuality),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: pricing.prices.entries.map((entry) {
                  return Text('${entry.key}: \$${entry.value}');
                }).toList(),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class Pricing {
  final String washQuality;
  final Map<String, double> prices;

  Pricing({required this.washQuality, required this.prices});
}

List<Pricing> pricingList = [
  Pricing(
    washQuality: 'Standard',
    prices: {'Small': 10.0, 'Medium': 15.0, 'Large': 20.0},
  ),
  Pricing(
    washQuality: 'Deluxe',
    prices: {'Small': 20.0, 'Medium': 25.0, 'Large': 30.0},
  ),
  Pricing(
    washQuality: 'Premium',
    prices: {'Small': 30.0, 'Medium': 35.0, 'Large': 40.0},
  ),
];
