import 'package:time_tracker/src/models/user.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/src/services/auth.dart';
import 'package:flutter/material.dart';
import '../screens/sign_in/sign_in_page.dart';
import '../screens/home_page.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    return StreamBuilder(
      stream: auth.onAuthStateChanged,
      builder: (context, AsyncSnapshot<User> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          return user != null ? HomePage() : SignInPage.create(context);
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
