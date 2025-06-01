import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';
import '../models/message.dart';
import '../utils/constants.dart';
import 'auth_service.dart';

class ChatService {
  static const String baseUrl = ApiConstants.baseUrl;
  WebSocketChannel? _channel;
  Function(Message)? _onMessageReceived;

  // Get chat messages with pagination
  Future<List<Message>> getMessages({
    required String otherUserId,
    int page = 0,
    int size = 20,
  }) async {
    try {
      final token = await AuthService.getToken();
      final queryParams = {
        'otherUserId': otherUserId,
        'page': page.toString(),
        'size': size.toString(),
      };

      final response = await http.get(
        Uri.parse('$baseUrl/api/messages')
            .replace(queryParameters: queryParams),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Message.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load messages: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load messages: $e');
    }
  }

  // Send a message
  Future<Message> sendMessage({
    required String recipientId,
    required String content,
    String? mediaUrl,
    String? mediaType,
  }) async {
    try {
      final token = await AuthService.getToken();

      final response = await http.post(
        Uri.parse('$baseUrl/api/messages'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'recipientId': recipientId,
          'content': content,
          'mediaUrl': mediaUrl,
          'mediaType': mediaType,
        }),
      );

      if (response.statusCode == 201) {
        return Message.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to send message: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  // Mark messages as read
  Future<void> markMessagesAsRead(String senderId) async {
    try {
      final token = await AuthService.getToken();

      final response = await http.put(
        Uri.parse('$baseUrl/api/messages/read/$senderId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to mark messages as read: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to mark messages as read: $e');
    }
  }

  // Get unread messages count
  Future<int> getUnreadCount() async {
    try {
      final token = await AuthService.getToken();

      final response = await http.get(
        Uri.parse('$baseUrl/api/messages/unread-count'),
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

  // Connect to WebSocket for real-time messages
  void connectToWebSocket(Function(Message) onMessageReceived) async {
    _onMessageReceived = onMessageReceived;
    final token = await AuthService.getToken();
    final wsUrl = baseUrl.replaceFirst('http', 'ws');

    _channel = WebSocketChannel.connect(
      Uri.parse('$wsUrl/ws/chat?token=$token'),
    );

    _channel!.stream.listen(
      (message) {
        final msg = Message.fromJson(jsonDecode(message));
        _onMessageReceived?.call(msg);
      },
      onError: (error) {
        print('WebSocket error: $error');
        // Try to reconnect after a delay
        Future.delayed(const Duration(seconds: 5), () {
          connectToWebSocket(onMessageReceived);
        });
      },
      onDone: () {
        print('WebSocket connection closed');
        // Try to reconnect after a delay
        Future.delayed(const Duration(seconds: 5), () {
          connectToWebSocket(onMessageReceived);
        });
      },
    );
  }

  // Disconnect from WebSocket
  void disconnect() {
    _channel?.sink.close();
    _channel = null;
    _onMessageReceived = null;
  }
}
