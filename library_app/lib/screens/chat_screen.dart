import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:library_app/models/message.dart';
import 'package:library_app/models/user.dart';
import 'package:library_app/providers/storage.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

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
  User? selectedUserData;

  @override
  void initState() {
    super.initState();

    currentUser = 'http://127.0.0.1:8080/api/currentUser';
    super.initState();
    // fetchUsers();
    fetchMessages();
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
        'Authorization': 'Bearer ${Storage().token}',
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
        title: const Text('Chat with Other Users'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56.0),
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
                      prefixIcon:
                          const Icon(Icons.search, color: Colors.pinkAccent),
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
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: fetchUsers,
          ),
          IconButton(
            icon: const Icon(
              Icons.connect_without_contact,
              color: Colors.white,
            ),
            onPressed: () {
              http.get(
                Uri.parse(
                  "http://127.0.0.1:8080/api/users/$selectedUser",
                ),
                headers: {'Authorization': 'Bearer ${Storage().token}'},
              ).then((response) {
                if (selectedUser != null && response.statusCode == 200) {
                  selectedUserData = User.fromJson(json.decode(response.body));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Connected to $selectedUser')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text('Please enter a valid username to connect')),
                  );
                }
              });
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
                  subtitle: Text(
                    'To: ${message.receiverId}\n${message.content}',
                  ),
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
                    decoration: const InputDecoration(
                      labelText: 'Enter message',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.pinkAccent),
                  onPressed: () async {
                    if (_messageController.text.isNotEmpty &&
                        selectedUser != null) {
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
                        print(response.body);
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
