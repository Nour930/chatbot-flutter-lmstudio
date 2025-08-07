import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart'; // Cet import est nécessaire
import 'package:chatbot/models/message.dart';

class MessageBubble extends StatefulWidget {
  final Message message;
  final AnimationController animationController;

  const MessageBubble({
    Key? key,
    required this.message,
    required this.animationController,
  }) : super(key: key);

  @override
  _MessageBubbleState createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    
    _slideAnimation = Tween<Offset>(
      begin: Offset(widget.message.isUser ? 1.0 : -1.0, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutBack,
    ));
    
    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: widget.message.isUser
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!widget.message.isUser) ...[
              CircleAvatar(
                radius: 16,
                backgroundColor: Color(0xFF667eea),
                child: Icon(
                  Icons.smart_toy,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              SizedBox(width: 8),
            ],
            Flexible(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: widget.message.isUser
                      ? Color(0xFF667eea)
                      : Colors.grey[200],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(widget.message.isUser ? 20 : 4),
                    bottomRight: Radius.circular(widget.message.isUser ? 4 : 20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha((255 * 0.1).round()),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!widget.message.isUser)
                      AnimatedTextKit(
                        animatedTexts: [
                          TypewriterAnimatedText(
                            widget.message.text,
                            textStyle: TextStyle(
                              color: widget.message.isUser
                                  ? Colors.white
                                  : Colors.black87,
                              fontSize: 16,
                            ),
                            speed: Duration(milliseconds: 30),
                          ),
                        ],
                        totalRepeatCount: 1,
                        displayFullTextOnTap: true,
                      )
                    else
                      Text(
                        widget.message.text,
                        style: TextStyle(
                          color: widget.message.isUser
                              ? Colors.white
                              : Colors.black87,
                          fontSize: 16,
                        ),
                      ),
                    SizedBox(height: 4),
                    Text(
                      _formatTime(widget.message.timestamp),
                      style: TextStyle(
                        color: widget.message.isUser
                            ? Colors.white70
                            : Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (widget.message.isUser) ...[
              SizedBox(width: 8),
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.grey[300],
                child: Icon(
                  Icons.person,
                  color: Colors.grey[600],
                  size: 16,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }
}
