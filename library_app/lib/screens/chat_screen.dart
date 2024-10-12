import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:library_app/models/message.dart';
import 'package:library_app/models/user_data.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<String> users = [];
  final String apiUrl = 'http://127.0.0.1:8080/api/users';
  final String messagesApiUrl = 'http://127.0.0.1:8080/api/messages';
  List<Message> messages = [];
  String? currentUser = 'http://127.0.0.1:8080/api/currentUser';
  String? selectedUser;

  @override
  void initState() {
    super.initState();

    currentUser = 'http://127.0.0.1:8080/api/currentUser';
    super.initState();
    fetchUsers();
    fetchMessages();
  }

  Future<void> fetchUsers() async {
    try {
      final response = await http.get(Uri.parse(apiUrl), headers: {
        'Authorization': 'Bearer ${UserData().token}',
      });
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          users = data.map((user) => user['username'].toString()).toList();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to load users: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  Future<void> fetchMessages() async {
    try {
      final response = await http.get(Uri.parse(messagesApiUrl), headers: {
        'Authorization': 'Bearer ${UserData().token}',
      });
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          messages = data.map((message) => Message.fromJson(message)).toList();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to load messages: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with Other Users'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(56.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search users...',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: Icon(Icons.search, color: Colors.pinkAccent),
                    ),
                    onChanged: (value) {
                      setState(() {
                        selectedUser = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: fetchUsers,
          ),
          IconButton(
            icon: Icon(Icons.connect_without_contact, color: Colors.white),
            onPressed: () {
              if (selectedUser != null && users.contains(selectedUser)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Connected to $selectedUser')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content:
                          Text('Please enter a valid username to connect')),
                );
              }
            },
          ),
        ],
        backgroundColor: Colors.pinkAccent,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final Message message = messages[index];
                return ListTile(
                  title: Text('From: ${message.senderId}'),
                  subtitle:
                      Text('To: ${message.receiverId}\n${message.content}'),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      labelText: 'Enter message',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.pinkAccent),
                  onPressed: () async {
                    if (_messageController.text.isNotEmpty &&
                        selectedUser != null) {
                      final newMessage = Message(
                        id: UserData().user!.id,
                        senderId: UserData().user!.username,
                        receiverId: users.indexOf(selectedUser!) + 1,
                        content: _messageController.text,
                      );

                      try {
                        final response = await http.post(
                          Uri.parse(messagesApiUrl),
                          headers: {
                            'Content-Type': 'application/json',
                            'Authorization': 'Bearer ${UserData().token}',
                          },
                          body: json.encode(newMessage.toJson()),
                        );
                        if (response.statusCode == 200 ||
                            response.statusCode == 201) {
                          setState(() {
                            messages.add(newMessage);
                          });
                          _messageController.clear();
                        } else {
                          var res =
                              'Failed to send message: ${response.statusCode}: ${response.body}';
                          print(res);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                res,
                              ),
                            ),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('An error occurred: $e')),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
