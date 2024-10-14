import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:library_app/models/message.dart';
import 'package:library_app/models/user.dart';
import 'package:library_app/providers/storage.dart';
class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  List<String> users = [];
  final String apiUrl = 'http://127.0.0.1:8080/api/users';
  final String messagesApiUrl = 'http://127.0.0.1:8080/api/messages';
  List<Message> messages = [];
  String? currentUser = 'http://127.0.0.1:8080/api/currentUser';
  String? selectedUser;
  User? selectedUserData;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late AnimationController _typeAnimationController;

  @override
  void initState() {
    super.initState();
    currentUser = 'http://127.0.0.1:8080/api/currentUser';
    fetchMessages();
    _typeAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _typeAnimationController.dispose();
    super.dispose();
  }

  Future<void> fetchUsers() async {
    try {
      final response = await http.get(Uri.parse(apiUrl), headers: {
        'Authorization': 'Bearer ${Storage().token}',
      });
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          users = data.map((user) => user['username'].toString()).toList();
        });
      } else {
        _showSnackBar('Failed to load users: ${response.statusCode}');
      }
    } catch (e) {
      _showSnackBar('An error occurred: $e');
    }
  }

  Future<void> fetchMessages() async {
    try {
      final response = await http.get(Uri.parse(messagesApiUrl), headers: {
        'Authorization': 'Bearer ${Storage().token}',
      });
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          messages = data.map((message) => Message.fromJson(message)).toList();
        });
        _scrollToBottom();
      } else {
        _showSnackBar('Failed to load messages: ${response.statusCode}');
      }
    } catch (e) {
      _showSnackBar('An error occurred: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.pink[100]!, Colors.pink[50]!],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: _buildMessageList(),
              ),
              _buildMessageInput(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.pinkAccent),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search users...',
                border: InputBorder.none,
                prefixIcon: Icon(Icons.search, color: Colors.pinkAccent),
              ),
              onChanged: (value) {
                setState(() {
                  selectedUser = value;
                });
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.pinkAccent),
            onPressed: fetchUsers,
          ),
          IconButton(
            icon: Icon(Icons.connect_without_contact, color: Colors.pinkAccent),
            onPressed: _connectToUser,
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: messages.length,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemBuilder: (context, index) {
        final Message message = messages[index];
        final bool isMe = message.senderId == Storage().user.id;
        return _buildMessageBubble(message, isMe);
      },
    );
  }

  Widget _buildMessageBubble(Message message, bool isMe) {
    var text = Text(
                isMe ? 'You' : message.senderId.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isMe ? Colors.white : Colors.pinkAccent,
                ),
              );
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: ChatBubble(
        clipper: ChatBubbleClipper6(type: isMe ? BubbleType.sendBubble : BubbleType.receiverBubble),
        alignment: isMe ? Alignment.topRight : Alignment.topLeft,
        margin: EdgeInsets.only(top: 20),
        backGroundColor: isMe ? Colors.pinkAccent : Colors.white,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              text,
              SizedBox(height: 4),
              Text(
                message.content,
                style: TextStyle(color: isMe ? Colors.white : Colors.black87),
              ),
              SizedBox(height: 4),
              Text(
                DateFormat('HH:mm').format(DateTime.now()), // Replace with actual timestamp
                style: TextStyle(
                  fontSize: 10,
                  color: isMe ? Colors.white70 : Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  _typeAnimationController.forward();
                } else {
                  _typeAnimationController.reverse();
                }
              },
            ),
          ),
          SizedBox(width: 8),
          AnimatedBuilder(
            animation: _typeAnimationController,
            builder: (context, child) {
              return Transform.rotate(
                angle: _typeAnimationController.value * 2 * 3.14159,
                child: child,
              );
            },
            child: IconButton(
              icon: Icon(Icons.send, color: Colors.pinkAccent),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }

  void _connectToUser() async {
    if (selectedUser != null) {
      try {
        final response = await http.get(
          Uri.parse("http://127.0.0.1:8080/api/users/$selectedUser"),
          headers: {'Authorization': 'Bearer ${Storage().token}'},
        );
        if (response.statusCode == 200) {
          setState(() {
            selectedUserData = User.fromJson(json.decode(response.body));
          });
          _showSnackBar('Connected to $selectedUser');
        } else {
          _showSnackBar('Failed to connect to user');
        }
      } catch (e) {
        _showSnackBar('An error occurred: $e');
      }
    } else {
      _showSnackBar('Please enter a valid username to connect');
    }
  }

  void _sendMessage() async {
    if (_messageController.text.isNotEmpty && selectedUserData != null) {
      final newMessage = Message(
        id: Storage().user.id,
        senderId: Storage().user.id,
        receiverId: selectedUserData!.id,
        content: _messageController.text,
      );

      try {
        final response = await http.post(
          Uri.parse(messagesApiUrl),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${Storage().token}',
          },
          body: json.encode(newMessage.toJson()),
        );
        if (response.statusCode == 200 || response.statusCode == 201) {
          setState(() {
            messages.add(newMessage);
          });
          _messageController.clear();
          _scrollToBottom();
        } else {
          _showSnackBar('Failed to send message: ${response.statusCode}');
        }
      } catch (e) {
        _showSnackBar('An error occurred: $e');
      }
    }
  }
}