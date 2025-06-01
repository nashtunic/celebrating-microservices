import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/AuthProvider.dart';
import 'models/user.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).userData as User;
    return Scaffold(
      appBar: AppBar(title: const Text('User Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (user.profileImage != null)
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(user.profileImage!),
              ),
            const SizedBox(height: 16),
            Text('Display Name: ${user.displayName}',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Username: @${user.username}',
                style: const TextStyle(fontSize: 16, color: Colors.grey)),
            if (user.email != null) ...[
              const SizedBox(height: 8),
              Text('Email: ${user.email}',
                  style: const TextStyle(fontSize: 16)),
            ],
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatColumn('Followers', user.followersCount),
                _buildStatColumn('Following', user.followingCount),
              ],
            ),
            const SizedBox(height: 16),
            Text('Member since: ${_formatDate(user.createdAt)}',
                style: const TextStyle(fontSize: 14, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, int count) {
    return Column(
      children: [
        Text(count.toString(),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
