import 'package:flutter/material.dart';
import 'package:time_tracker/src/screens/sign_in/email_sign_in_form_bloc_base.dart';
import 'package:time_tracker/src/screens/sign_in/email_sign_in_form_change_notifier.dart';

class EmailSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
        elevation: 10.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            child: EmailSignInChangeNotifier.create(context),
          ),
        ),
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}
