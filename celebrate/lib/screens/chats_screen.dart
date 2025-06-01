import 'package:flutter/material.dart';
import '../models/message.dart';
import '../models/user.dart';
import '../services/messaging_service.dart';
import '../services/user_service.dart';
import 'chat_screen.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  final MessagingService _messagingService = MessagingService();
  final UserService _userService = UserService();
  List<Chat> _chats = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadChats();
  }

  Future<void> _loadChats() async {
    try {
      final chats = await _messagingService.getChats();
      setState(() {
        _chats = chats;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading chats: $e')),
        );
      }
    }
  }

  Future<void> _startNewChat() async {
    try {
      final users = await _userService.searchUsers('');
      if (!mounted) return;

      final selectedUser = await showDialog<User>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Select User'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: user.profileImage != null
                        ? NetworkImage(user.profileImage!)
                        : null,
                    child: user.profileImage == null
                        ? Text(user.displayName[0])
                        : null,
                  ),
                  title: Text(user.displayName),
                  subtitle: Text(user.username),
                  onTap: () => Navigator.pop(context, user),
                );
              },
            ),
          ),
        ),
      );

      if (selectedUser != null) {
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                otherUserId: selectedUser.id.toString(),
                otherUserName: selectedUser.displayName,
                otherUserProfileImage: selectedUser.profileImage,
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error starting new chat: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement chat search
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _chats.length,
              itemBuilder: (context, index) {
                final chat = _chats[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: chat.otherUserProfileImage != null
                        ? NetworkImage(chat.otherUserProfileImage!)
                        : null,
                    child: chat.otherUserProfileImage == null
                        ? Text(chat.otherUserName[0])
                        : null,
                  ),
                  title: Text(chat.otherUserName),
                  subtitle: chat.lastMessage != null
                      ? Text(
                          chat.lastMessage!.content,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                      : null,
                  trailing: chat.unreadCount > 0
                      ? Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            chat.unreadCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12.0,
                            ),
                          ),
                        )
                      : Text(
                          chat.lastMessage != null
                              ? _formatTime(chat.lastMessage!.createdAt)
                              : '',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          otherUserId: chat.otherUserId,
                          otherUserName: chat.otherUserName,
                          otherUserProfileImage: chat.otherUserProfileImage,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _startNewChat,
        child: const Icon(Icons.message),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    if (time.year == now.year &&
        time.month == now.month &&
        time.day == now.day) {
      return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
    } else if (time.year == now.year) {
      return '${time.day}/${time.month}';
    } else {
      return '${time.day}/${time.month}/${time.year}';
    }
  }
}
