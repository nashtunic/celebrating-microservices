import 'package:flutter/material.dart';
import '../models/notification.dart' as app_notification;
import '../services/notification_service.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final NotificationService _notificationService = NotificationService();
  final List<app_notification.Notification> _notifications = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
    _scrollController.addListener(_onScroll);
    _setupWebSocket();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _notificationService.disconnect();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadNotifications();
    }
  }

  void _setupWebSocket() {
    _notificationService.connectToWebSocket((notification) {
      setState(() {
        _notifications.insert(0, notification);
      });
    });
  }

  Future<void> _loadNotifications() async {
    if (!_hasMore || _isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final notifications = await _notificationService.getNotifications(
        page: _currentPage,
      );

      setState(() {
        _notifications.addAll(notifications);
        _isLoading = false;
        _hasMore = notifications.isNotEmpty;
        if (_hasMore) _currentPage++;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading notifications: $e')),
        );
      }
    }
  }

  Future<void> _markAllAsRead() async {
    try {
      await _notificationService.markAllAsRead();
      setState(() {
        for (var notification in _notifications) {
          notification = app_notification.Notification(
            id: notification.id,
            userId: notification.userId,
            title: notification.title,
            message: notification.message,
            type: notification.type,
            targetId: notification.targetId,
            targetType: notification.targetType,
            isRead: true,
            createdAt: notification.createdAt,
          );
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error marking notifications as read: $e')),
        );
      }
    }
  }

  Widget _buildNotificationItem(app_notification.Notification notification) {
    IconData icon;
    Color color;

    switch (notification.type) {
      case 'like':
        icon = Icons.favorite;
        color = Colors.red;
        break;
      case 'comment':
        icon = Icons.comment;
        color = Colors.blue;
        break;
      case 'rating':
        icon = Icons.star;
        color = Colors.amber;
        break;
      default:
        icon = Icons.notifications;
        color = Colors.grey;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      color: notification.isRead ? null : Colors.blue.shade50,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(notification.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(notification.message),
            const SizedBox(height: 4),
            Text(
              _formatTime(notification.createdAt),
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
        onTap: () async {
          if (!notification.isRead) {
            try {
              await _notificationService.markAsRead(notification.id);
              setState(() {
                notification = app_notification.Notification(
                  id: notification.id,
                  userId: notification.userId,
                  title: notification.title,
                  message: notification.message,
                  type: notification.type,
                  targetId: notification.targetId,
                  targetType: notification.targetType,
                  isRead: true,
                  createdAt: notification.createdAt,
                );
              });
            } catch (e) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('Error marking notification as read: $e')),
                );
              }
            }
          }
          // TODO: Navigate to the target content based on targetId and targetType
        },
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${time.day}/${time.month}/${time.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (_notifications.any((n) => !n.isRead))
            IconButton(
              icon: const Icon(Icons.done_all),
              onPressed: _markAllAsRead,
              tooltip: 'Mark all as read',
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _notifications.clear();
            _currentPage = 0;
            _hasMore = true;
          });
          await _loadNotifications();
        },
        child: _notifications.isEmpty && !_isLoading
            ? const Center(
                child: Text('No notifications'),
              )
            : ListView.builder(
                controller: _scrollController,
                itemCount: _notifications.length + (_hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _notifications.length) {
                    return _isLoading
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : const SizedBox();
                  }
                  return _buildNotificationItem(_notifications[index]);
                },
              ),
      ),
    );
  }
}
