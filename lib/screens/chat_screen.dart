import 'package:flutter/material.dart';

import 'package:chatbot/models/message.dart';           // Changé ici
import 'package:chatbot/services/chat_service.dart';    // Changé ici
import 'package:chatbot/services/database_service.dart'; // Changé ici
import 'package:chatbot/widgets/message_bubble.dart';   // Changé ici
import 'package:chatbot/widgets/typing_indicator.dart'; // Changé ici

class ChatScreen extends StatefulWidget {
  final String username;

  const ChatScreen({Key? key, required this.username}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ChatService _chatService = ChatService();
  final DatabaseService _databaseService = DatabaseService();
  
  List<Message> _messages = [];
  bool _isTyping = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _loadMessages();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMessages() async {
    final messages = await _databaseService.getMessages();
    setState(() {
      _messages = messages;
    });
    _scrollToBottom();
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final userMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: _messageController.text.trim(),
      isUser: true,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(userMessage);
      _isTyping = true;
    });

    await _databaseService.insertMessage(userMessage);
    _messageController.clear();
    _scrollToBottom();

    try {
      final response = await _chatService.sendMessage(userMessage.text);
      
      final botMessage = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: response,
        isUser: false,
        timestamp: DateTime.now(),
      );

      setState(() {
        _messages.add(botMessage);
        _isTyping = false;
      });

      await _databaseService.insertMessage(botMessage);
      _scrollToBottom();
    } catch (e) {
      setState(() {
        _isTyping = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: ${e.toString()}')),
      );
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _clearChat() async {
    await _databaseService.clearMessages();
    setState(() {
      _messages.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.green,
              radius: 8,
            ),
            SizedBox(width: 8),
            Text('Mistral AI'),
          ],
        ),
        backgroundColor: Color(0xFF667eea),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.clear_all),
            onPressed: _clearChat,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF667eea).withAlpha((255 * 0.1).round()),
              Colors.white,
            ],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.all(16),
                itemCount: _messages.length + (_isTyping ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _messages.length && _isTyping) {
                    return TypingIndicator();
                  }
                  
                  final message = _messages[index];
                  return MessageBubble(
                    message: message,
                    animationController: _animationController,
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Tapez votre message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                      maxLines: null,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF667eea),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.send, color: Colors.white),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
