import 'package:flutter/material.dart';
import '../services/notification_service.dart';
import '../services/chat_service.dart';
import 'home_screen.dart';
import 'notifications_screen.dart';
import 'chat_list_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final NotificationService _notificationService = NotificationService();
  final ChatService _chatService = ChatService();
  int _unreadNotifications = 0;
  int _unreadMessages = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const ChatListScreen(),
    const NotificationsScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _loadUnreadCounts();
    _setupNotificationWebSocket();
  }

  @override
  void dispose() {
    _notificationService.disconnect();
    _chatService.disconnect();
    super.dispose();
  }

  Future<void> _loadUnreadCounts() async {
    try {
      final notificationCount = await _notificationService.getUnreadCount();
      final messageCount = await _chatService.getUnreadCount();

      if (mounted) {
        setState(() {
          _unreadNotifications = notificationCount;
          _unreadMessages = messageCount;
        });
      }
    } catch (e) {
      print('Error loading unread counts: $e');
    }
  }

  void _setupNotificationWebSocket() {
    _notificationService.connectToWebSocket((notification) {
      if (mounted && !notification.isRead) {
        setState(() {
          _unreadNotifications++;
        });
      }
    });

    _chatService.connectToWebSocket((message) {
      if (mounted && !message.isRead) {
        setState(() {
          _unreadMessages++;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          // Reset badge count when navigating to notifications or chats
          if (index == 1 && _unreadMessages > 0) {
            setState(() {
              _unreadMessages = 0;
            });
          } else if (index == 2 && _unreadNotifications > 0) {
            setState(() {
              _unreadNotifications = 0;
            });
          }
        },
        type: BottomNavigationBarType.fixed,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Badge(
              isLabelVisible: _unreadMessages > 0,
              label: Text(_unreadMessages.toString()),
              child: const Icon(Icons.chat),
            ),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Badge(
              isLabelVisible: _unreadNotifications > 0,
              label: Text(_unreadNotifications.toString()),
              child: const Icon(Icons.notifications),
            ),
            label: 'Notifications',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
