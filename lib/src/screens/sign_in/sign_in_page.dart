import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/src/services/auth.dart';

import 'package:time_tracker/src/services/sign_in_manager.dart';
// import '../sign_in/sign_in_manager.dart';
import '../sign_in/sign_in_button.dart';
import '../sign_in/social_sign_in_button.dart';
import '../sign_in/email_sign_page.dart';

class SignInPage extends StatelessWidget {
  
  

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, isLoading, __) => Provider<SignInManager>(
          create: (context) => SignInManager(auth: auth, isLoading: isLoading),
          child: Consumer<SignInManager>(
            builder: (context, manager, _) =>
                SignInPage(manager: manager, isLoading: isLoading.value),
          ),
        ),
      ),
    );
  }

  final SignInManager manager;
  final bool isLoading;

  const SignInPage({Key key, @required this.manager, @required this.isLoading})
      : super(key: key);


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Tracker'),
        elevation: 10.0,
      ),
      body: _buildContent(context),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 50.0,
            child: _buildHeader(),
          ),
          SizedBox(height: 20.0),
          SocialSignInButton(
            text: 'Sign In With Google',
            assetName: 'images/google-logo.png',
            textColor: Colors.black87,
            color: Colors.white,
            onPressed: isLoading ? null : () => _signInWithGoogle(context),
          ),
          SizedBox(height: 8.0),
          SocialSignInButton(
            text: 'Sign In With Facebook',
            assetName: 'images/facebook-logo.png',
            textColor: Colors.white,
            color: Colors.blue[700],
            onPressed: () {},
          ),
          SizedBox(height: 8.0),
          SignInButton(
            text: 'Sign In With Email',
            textColor: Colors.white,
            color: Colors.teal[700],
            onPressed: isLoading ? null : () => _signInWithEmail(context),
          ),
          Text(
            'Or',
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          SignInButton(
            text: 'Go Anonymous',
            textColor: Colors.black,
            color: Colors.lime[700],
            onPressed: isLoading ? null : () => _signInAnonymously(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Text(
      'Sign In',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 30.0,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await manager.signInWithGoogle();
    } catch (e) {
      print(e.toString());
    }
  }

  void _signInWithEmail(context) {
    Navigator.of(context).push(MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (context) => EmailSignInPage(),
    ));
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      await manager.signInAnonymously();
    } catch (e) {
      print(e.toString());
    }
  }
}
