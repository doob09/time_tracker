import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:time_tracker/src/models/user.dart';
import 'package:time_tracker/src/services/auth.dart';

class SignInManager {
  final AuthBase auth;
  final ValueNotifier<bool> isLoading;

  SignInManager({@required this.auth, @required this.isLoading});


  
  

  Future<User> signInAnonymously() async => _signIn(auth.signInAnonymously);
  Future<User> signInWithGoogle() async => _signIn(auth.signInWithGoogle);

  Future<User> _signIn(Future<User> Function() signInMethod) async {
    try {
      isLoading.value = true;
      return await signInMethod();
    } catch (e) {
      isLoading.value = false;
      rethrow;
    }
  }
}
