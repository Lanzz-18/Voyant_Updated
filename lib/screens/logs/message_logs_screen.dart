import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../components/info_prompt_popup.dart';

class MessageLogsRepository {
  static const String _baseUrl = 'http://localhost:3000/api/messages';
  
  static Future<List<Message>> getUserMessages(String userId, {
    int page = 1,
    int limit = 20,
    bool? isRead,
    String? messageType,
  }) async {
    try {
      final queryParams = <String, String>{
    //setting up the page anmd limit for how many messages it can have 
        'page': page.toString(),
        'limit': limit.toString(),
      };
      
      //filters to filter out unread or specific type of messages like rewards
      if (isRead != null) {
        queryParams['isRead'] = isRead.toString();
      }
      
      if (messageType != null) {
        queryParams['messageType'] = messageType;
      }

      final uri = Uri.parse('$_baseUrl/user/$userId').replace(queryParameters: queryParams);
      
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> messagesList = data['messages'];
        return messagesList.map((json) => Message.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load messages: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  static Future<int> getUnreadCount(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/user/$userId/unread-count'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['unreadCount'] ?? 0;
      } else {
        throw Exception('Failed to get unread count: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  static Future<void> markAllAsRead(String userId) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/user/$userId/mark-all-read'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('Failed to mark all as read: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}