import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/AuthProvider.dart';
import '../models/user.dart';

class UserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).userData as User;
    return Scaffold(
      appBar: AppBar(title: Text('User Profile')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Username: ${user.username}', style: TextStyle(fontSize: 20)),
            Text('Email: ${user.email}'),
            Text('Followers: ${user.followersCount}'),
            // Add more fields as needed
          ],
        ),
      ),
    );
  }
}
