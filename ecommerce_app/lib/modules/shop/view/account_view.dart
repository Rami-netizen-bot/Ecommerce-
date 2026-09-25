import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'order_history_view.dart';
import 'login_view.dart';

class AccountView extends StatelessWidget {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Account')),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          // Profile Header
          UserAccountsDrawerHeader(
            accountName: Text(
              'Ramy Man',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            accountEmail: Text('ramy@example.com'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 50, color: Colors.blueAccent),
            ),
            decoration: BoxDecoration(color: Colors.blueAccent),
          ),
          SizedBox(height: 10),
          // Order
          ListTile(
            leading: Icon(Icons.shopping_bag_outlined, color: Colors.indigo),
            title: Text('My Orders'),
            subtitle: Text('View order details and history'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () => Get.to(() => OrderHistoryView()),
          ),
          Divider(),
          // Addresses
          ListTile(
            leading: Icon(Icons.location_on_outlined, color: Colors.indigo),
            title: Text('Shopping Addresses'),
            subtitle: Text('Add or Edit delivery address'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Get.snackbar("Info", "Address management feature coming soon");
            },
          ),
        ],
      ),
    );
  }
}
