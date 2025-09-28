import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserListState extends StatelessWidget {
  final streamOFfUsers = FirebaseFirestore.instance
      .collection('users')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: streamOFfUsers,
      builder: (ctx, userListSnapshot) {
        if (userListSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!userListSnapshot.hasData || userListSnapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No Users Added So far'));
        }

        if (userListSnapshot.hasError) {
          return const Text('Something went wrong !!');
        }

        final loadUsers = userListSnapshot.data!.docs;

        return ListView.builder(
          itemCount: loadUsers.length,
          itemBuilder: (ctx, index) => Card(
            color: Colors.blue.shade400,
            elevation: 2.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    loadUsers[index].data()['username'],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Widget _userDetailLayout() {
  //   return Padding(
  //     padding: const EdgeInsets.all(12.0),
  //     child: Card(
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         mainAxisSize: MainAxisSize.min,
  //         children: [Text()],
  //       ),
  //     ),
  //   );
  // }
}
