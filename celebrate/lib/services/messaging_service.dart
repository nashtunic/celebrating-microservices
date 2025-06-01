import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';
import '../models/message.dart';
import '../utils/constants.dart';
import 'package:celebrate/AuthService.dart';

class MessagingService {
  static const String baseUrl = ApiConstants.baseUrl;
  WebSocketChannel? _channel;
  Function(Message)? _onMessageReceived;

  // Get user's chats
  Future<List<Chat>> getChats() async {
    try {
      final token = await AuthService.getToken();
      final userId = await AuthService.getUserId();

      final response = await http.get(
        Uri.parse('$baseUrl/api/messages/chats'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'X-User-ID': userId.toString(),
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Chat.fromJson(json)).toList();
      } else {
        throw Exception('Failed to get chats: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get chats: $e');
    }
  }

  // Get chat messages
  Future<List<Message>> getChatMessages(String chatId) async {
    try {
      final token = await AuthService.getToken();
      final userId = await AuthService.getUserId();

      final response = await http.get(
        Uri.parse('$baseUrl/api/messages/chat/$chatId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'X-User-ID': userId.toString(),
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Message.fromJson(json)).toList();
      } else {
        throw Exception('Failed to get messages: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get messages: $e');
    }
  }

  // Send a message
  Future<Message> sendMessage(String receiverId, String content) async {
    try {
      final token = await AuthService.getToken();
      final userId = await AuthService.getUserId();

      final response = await http.post(
        Uri.parse('$baseUrl/api/messages'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'X-User-ID': userId.toString(),
        },
        body: jsonEncode({
          'receiverId': receiverId,
          'content': content,
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
  Future<void> markAsRead(String chatId) async {
    try {
      final token = await AuthService.getToken();
      final userId = await AuthService.getUserId();

      final response = await http.put(
        Uri.parse('$baseUrl/api/messages/chat/$chatId/read'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'X-User-ID': userId.toString(),
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
