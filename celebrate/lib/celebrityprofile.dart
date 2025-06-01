import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/AuthProvider.dart';
import 'models/celebrity.dart';

class CelebrityProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final celebrity = Provider.of<AuthProvider>(context).userData as Celebrity;
    return Scaffold(
      appBar: AppBar(title: Text('Celebrity Profile')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Stage Name: ${celebrity.stageName}',
                style: TextStyle(fontSize: 20)),
            Text('Full Name: ${celebrity.fullName}'),
            Text('Net Worth: ${celebrity.netWorth}'),
            // Add more fields as needed
          ],
        ),
      ),
    );
  }
}
