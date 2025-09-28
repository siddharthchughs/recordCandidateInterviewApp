import 'package:flutter/material.dart';
import 'package:fluttercandidateinterviewapp/widget/screens/user_list_state.dart';

class ListOfUsers extends StatelessWidget {
  const ListOfUsers({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Users'),
          leading: BackButton(onPressed: () => {Navigator.of(context).pop()}),
        ),
        body: Column(children: [Expanded(child: UserListState())]),
      ),
    );
  }
}
