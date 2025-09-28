import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttercandidateinterviewapp/widget/screens/chat_messages.dart';
import 'package:fluttercandidateinterviewapp/widget/screens/list_of_users.dart';
import 'package:fluttercandidateinterviewapp/widget/screens/new_messages.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Widget content = Column(
      children: const [
        Expanded(child: ChatMessages()),
        NewMessages(),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('List Of Jobs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.blueAccent),
            tooltip: 'Show Snackbar',
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
          ),
          IconButton(
            icon: const Icon(Icons.contact_page, color: Colors.blueAccent),
            tooltip: 'Users',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => ListOfUsers(),
                ),
              );
            },
          ),
        ],
      ),
      body: content,
    );
  }
}
