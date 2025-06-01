import 'package:flutter/material.dart';
import '../models/celebrity.dart';

class CelebrityListItem extends StatelessWidget {
  final Celebrity celebrity;

  const CelebrityListItem({
    Key? key,
    required this.celebrity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: celebrity.profileImage != null
            ? NetworkImage(celebrity.profileImage!)
            : null,
        child: celebrity.profileImage == null
            ? Text(celebrity.displayName[0].toUpperCase())
            : null,
      ),
      title: Row(
        children: [
          Text(celebrity.displayName),
          const SizedBox(width: 8),
          const Icon(
            Icons.verified,
            color: Colors.blue,
            size: 16,
          ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('@${celebrity.username}'),
          if (celebrity.category != null)
            Text(
              celebrity.category!,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 12,
              ),
            ),
        ],
      ),
      trailing: TextButton(
        onPressed: () {
          // TODO: Navigate to celebrity profile
        },
        child: const Text('View Profile'),
      ),
    );
  }
}
