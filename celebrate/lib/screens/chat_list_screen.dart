import 'package:flutter/material.dart';
import '../models/message.dart';
import '../services/chat_service.dart';
import 'chat_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final List<Chat> _chats = [];
  final ChatService _chatService = ChatService();
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadChats();
    _scrollController.addListener(_onScroll);
    _setupWebSocket();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadChats();
    }
  }

  void _setupWebSocket() {
    _chatService.connectToWebSocket((message) {
      // Update the chat list when a new message is received
      final chatIndex = _chats.indexWhere((chat) =>
          chat.otherUserId == message.senderId ||
          chat.otherUserId == message.recipientId);

      if (chatIndex != -1) {
        setState(() {
          final chat = _chats[chatIndex];
          _chats[chatIndex] = Chat(
            id: chat.id,
            userId: chat.userId,
            otherUserId: chat.otherUserId,
            otherUserName: chat.otherUserName,
            otherUserProfileImage: chat.otherUserProfileImage,
            lastMessage: message,
            unreadCount: chat.unreadCount + 1,
          );
          // Move the chat to the top of the list
          _chats.insert(0, _chats.removeAt(chatIndex));
        });
      }
    });
  }

  Future<void> _loadChats() async {
    if (!_hasMore || _isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Implement chat list pagination in the backend
      await Future.delayed(const Duration(seconds: 1)); // Simulated delay
      setState(() {
        _isLoading = false;
        _hasMore = false; // For now, load all chats at once
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading chats: $e')),
        );
      }
    }
  }

  void _navigateToChat(Chat chat) {
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
  }

  Widget _buildChatItem(Chat chat) {
    return ListTile(
      leading: chat.otherUserProfileImage != null
          ? CircleAvatar(
              backgroundImage: NetworkImage(chat.otherUserProfileImage!),
            )
          : CircleAvatar(
              child: Text(chat.otherUserName[0]),
            ),
      title: Text(chat.otherUserName),
      subtitle: chat.lastMessage != null
          ? Text(
              chat.lastMessage!.content,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          : null,
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (chat.lastMessage != null)
            Text(
              _formatTime(chat.lastMessage!.createdAt),
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          if (chat.unreadCount > 0)
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                chat.unreadCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
      onTap: () => _navigateToChat(chat),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    if (now.difference(time).inDays == 0) {
      return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
    } else if (now.difference(time).inDays == 1) {
      return 'Yesterday';
    } else if (now.difference(time).inDays < 7) {
      switch (time.weekday) {
        case 1:
          return 'Mon';
        case 2:
          return 'Tue';
        case 3:
          return 'Wed';
        case 4:
          return 'Thu';
        case 5:
          return 'Fri';
        case 6:
          return 'Sat';
        case 7:
          return 'Sun';
        default:
          return '';
      }
    } else {
      return '${time.day}/${time.month}';
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
      body: _chats.isEmpty && !_isLoading
          ? const Center(
              child: Text('No chats yet'),
            )
          : ListView.builder(
              controller: _scrollController,
              itemCount: _chats.length + (_hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _chats.length) {
                  return _isLoading
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : const SizedBox();
                }
                return _buildChatItem(_chats[index]);
              },
            ),
    );
  }
}
