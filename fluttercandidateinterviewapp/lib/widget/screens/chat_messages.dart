import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttercandidateinterviewapp/widget/message_bubble_layout.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    final authenticatedUser = FirebaseAuth.instance.currentUser!;

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, chatSnapshots) {
        if (chatSnapshots.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!chatSnapshots.hasData || chatSnapshots.data!.docs.isEmpty) {
          return const Center(child: Text('No Message Found'));
        }

        if (chatSnapshots.hasError) {
          return const Center(child: Text('Something went Wrong'));
        }

        final loadChatMessages = chatSnapshots.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 40, left: 14, right: 14),
          reverse: true,
          itemCount: loadChatMessages.length,
          itemBuilder: (cts, index) {
            final chatMessage = loadChatMessages[index].data();
            final nextChatMessage = index + 1 < loadChatMessages.length
                ? loadChatMessages[index + 1].data()
                : null;

            final currentMessageUserId = chatMessage['userId'];
            final nextMesssageUserId = nextChatMessage != null
                ? nextChatMessage['userId']
                : null;
            final nextUserIdSame = nextMesssageUserId == currentMessageUserId;

            if (nextUserIdSame) {
              return MessageBubble.next(
                message: chatMessage['text'],
                isMe: authenticatedUser.uid == currentMessageUserId,
              );
            } else {
              return MessageBubble.first(
                userImage: chatMessage['profileimage'],
                username: chatMessage['username'],
                message: chatMessage['text'],
                isMe: authenticatedUser.uid == currentMessageUserId,
              );
            }
          },
        );
      },
    );
  }
}
