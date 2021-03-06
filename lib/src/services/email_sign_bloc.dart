import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:time_tracker/src/models/email_sign_in_model.dart';
import 'package:time_tracker/src/services/auth.dart';

class EmailSignInBloc {
  final AuthBase auth;

  EmailSignInBloc({@required this.auth});

  final StreamController<EmailSignInModel> _emailSIController =
      StreamController<EmailSignInModel>();

  Stream<EmailSignInModel> get emailSIStream => _emailSIController.stream;

  EmailSignInModel _emailSIModel = EmailSignInModel();

  void dispose() {
    _emailSIController.close();
  }

  void updateWith({
    String email,
    String password,
    EmailSignInFormType formType,
    bool isLoading,
    bool submitted,
  }) {
    _emailSIModel = _emailSIModel.copyWith(
      email: email,
      password: password,
      formType: formType,
      isLoading: isLoading,
      submitted: submitted,
    );
    _emailSIController.add(_emailSIModel);
  }

  Future<void> submit() async {
    updateWith(submitted: true, isLoading: true);
    try {
      if (_emailSIModel.formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(
            _emailSIModel.email, _emailSIModel.password);
      } else {
        await auth.createUserWithEmailAndPassword(
            _emailSIModel.email, _emailSIModel.password);
      }
    } catch (e) {
      rethrow;
    } finally {
      updateWith(isLoading: false);
    }
  }
}
