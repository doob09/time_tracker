import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../src/screens/landing_page.dart';
import '../src/services/auth.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<AuthBase>(
      create: (context) => AuthService(),
      child: MaterialApp(
        title: 'Time Tracker',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: LandingPage(),
      ),
    );
  }
}
