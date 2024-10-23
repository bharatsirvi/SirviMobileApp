import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sirvi_mobile_app/models/userModel.dart';
import 'package:sirvi_mobile_app/provider/user_provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Column(
        children: [
          Text('name ${user.name}'),
          Text('Mobile: ${user.mobile}'),
          Text("password: ${user.password}"),
          Text("id: ${user.id}")
        ],
      ),
    );
  }
}
