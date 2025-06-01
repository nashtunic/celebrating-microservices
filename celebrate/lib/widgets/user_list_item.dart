import 'package:flutter/material.dart';
import '../models/user.dart';

class UserListItem extends StatelessWidget {
  final User user;

  const UserListItem({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage:
            user.profileImage != null ? NetworkImage(user.profileImage!) : null,
        child: user.profileImage == null
            ? Text(user.displayName[0].toUpperCase())
            : null,
      ),
      title: Text(user.displayName),
      subtitle: Text('@${user.username}'),
      trailing: TextButton(
        onPressed: () {
          // TODO: Navigate to user profile
        },
        child: const Text('View Profile'),
      ),
    );
  }
}
