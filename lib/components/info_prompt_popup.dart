import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Message {
  final String id;
  final String characterName;
  final String characterAvatar;
  final String message;
  final String messageType;
  final String location;
  final bool isRead;
  final DateTime timestamp;

  const Message({
    required this.id,
    required this.characterName,
    required this.characterAvatar,
    required this.message,
    required this.messageType,
    required this.location,
    required this.isRead,
    required this.timestamp,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['_id']?.toString() ?? '',
      characterName: json['characterName'] ?? '',
      characterAvatar: json['characterAvatar'] ?? '',
      message: json['message'] ?? '',
      messageType: json['messageType'] ?? 'info',
      location: json['location'] ?? '',
      isRead: json['isRead'] ?? false,
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

class MessageRepository {
  static const String _baseUrl = 'http://localhost:3000/api/messages';
  
  static Future<void> markMessageAsRead(String messageId, String userId) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/user/$userId/mark-read'), //api end point to mark message 
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'messageIds': [messageId],
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('Failed to mark message as read: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}

class _InfoPromptPopupState extends State<InfoPromptPopup>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;
  bool _isDismissing = false;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    //slide animation that starts the popup from top and brings it into the main screen area
    _slideAnimation = Tween<double>(
      begin: -1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    //makes it fade in 
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 1.0, curve: Curves.easeInOut),
    ));

    _controller.forward(); //starting animation 

    //remove the popup after 8 seconds 
    Future.delayed(const Duration(seconds: 8), () {
      if (mounted && !_isDismissing) {
        _dismissPopup();

      }
    });
  }

  //calls the dismiss function to remove the popup 
  Future<void> _dismissPopup() async {
    if (_isDismissing) return;
    
    _isDismissing = true;
    
    // Marks message as read
    try {
      await MessageRepository.markMessageAsRead(widget.message.id, widget.userId);
    } catch (e) {
      debugPrint('Failed to mark message as read: $e');
    }

    // dismiss animation
    await _controller.reverse();
    
    if (mounted) {
      widget.onDismiss?.call(widget.message.id); 
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


//dynamic styling for messages 
 Color _getMessageTypeColor() {
  //700 is used for a more darker swatch ( customizable to a lighter swatch )
    switch (widget.message.messageType) {
      case 'hint':
        return Colors.blue.shade700;
      case 'warning':
        return Colors.orange.shade700;
      case 'quest_update':
        return Colors.purple.shade700;
      case 'reward':
        return Colors.green.shade700;
      default:
        return Colors.grey.shade700;
    }
  }
  