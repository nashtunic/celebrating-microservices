import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';
import '../models/notification.dart';
import '../utils/constants.dart';
import 'auth_service.dart';

class NotificationService {
  static const String baseUrl = ApiConstants.baseUrl;
  WebSocketChannel? _channel;
  Function(Notification)? _onNotificationReceived;

  // Get notifications with pagination
  Future<List<Notification>> getNotifications({
    int page = 0,
    int size = 20,
    bool unreadOnly = false,
  }) async {
    try {
      final token = await AuthService.getToken();
      final queryParams = {
        'page': page.toString(),
        'size': size.toString(),
        if (unreadOnly) 'unreadOnly': 'true',
      };

      final response = await http.get(
        Uri.parse('$baseUrl/api/notifications')
            .replace(queryParameters: queryParams),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Notification.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load notifications: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load notifications: $e');
    }
  }

  // Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    try {
      final token = await AuthService.getToken();

      final response = await http.put(
        Uri.parse('$baseUrl/api/notifications/$notificationId/read'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to mark notification as read: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to mark notification as read: $e');
    }
  }

  // Mark all notifications as read
  Future<void> markAllAsRead() async {
    try {
      final token = await AuthService.getToken();

      final response = await http.put(
        Uri.parse('$baseUrl/api/notifications/read-all'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to mark all notifications as read: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to mark all notifications as read: $e');
    }
  }

  // Get unread notifications count
  Future<int> getUnreadCount() async {
    try {
      final token = await AuthService.getToken();

      final response = await http.get(
        Uri.parse('$baseUrl/api/notifications/unread-count'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return int.parse(response.body);
      } else {
        throw Exception('Failed to get unread count: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get unread count: $e');
    }
  }

  // Connect to WebSocket for real-time notifications
  void connectToWebSocket(Function(Notification) onNotificationReceived) async {
    _onNotificationReceived = onNotificationReceived;
    final token = await AuthService.getToken();
    final wsUrl = baseUrl.replaceFirst('http', 'ws');

    _channel = WebSocketChannel.connect(
      Uri.parse('$wsUrl/ws/notifications?token=$token'),
    );

    _channel!.stream.listen(
      (message) {
        final notification = Notification.fromJson(jsonDecode(message));
        _onNotificationReceived?.call(notification);
      },
      onError: (error) {
        print('WebSocket error: $error');
        // Try to reconnect after a delay
        Future.delayed(const Duration(seconds: 5), () {
          connectToWebSocket(onNotificationReceived);
        });
      },
      onDone: () {
        print('WebSocket connection closed');
        // Try to reconnect after a delay
        Future.delayed(const Duration(seconds: 5), () {
          connectToWebSocket(onNotificationReceived);
        });
      },
    );
  }

  // Disconnect from WebSocket
  void disconnect() {
    _channel?.sink.close();
    _channel = null;
    _onNotificationReceived = null;
  }
}
