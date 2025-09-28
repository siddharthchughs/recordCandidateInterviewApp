import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessages extends StatefulWidget {
  const NewMessages({super.key});

  @override
  State<NewMessages> createState() => _NewMessages();
}

class _NewMessages extends State<NewMessages> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    final enteredMessage = _messageController.text;
    if (enteredMessage.trim().isEmpty) {
      return;
    }
    FocusScope.of(context).unfocus();
    _messageController.clear();

    final userLoggedIn = FirebaseAuth.instance.currentUser!;

    final userInfo = await FirebaseFirestore.instance
        .collection('users')
        .doc(userLoggedIn.uid)
        .get();

    FirebaseFirestore.instance.collection('chat').add({
      'text': enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': userLoggedIn.uid,
      'username': userInfo.data()!['username'],
      'profileimage': userInfo.data()!['image_url'],
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 1, bottom: 14),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                label: const Text(
                  'Message',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 14,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ),
              enableSuggestions: true,
            ),
          ),
          IconButton(
            onPressed: _sendMessage,
            color: Theme.of(context).primaryColor,
            icon: Icon(Icons.send_rounded),
          ),
        ],
      ),
    );
  }
}
