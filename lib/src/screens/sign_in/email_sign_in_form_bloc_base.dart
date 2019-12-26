import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/src/models/email_sign_in_model.dart';
import 'package:time_tracker/src/screens/sign_in/validator.dart';
import 'package:time_tracker/src/services/auth.dart';
import 'package:time_tracker/src/services/email_sign_bloc.dart';
import 'package:time_tracker/src/widgets/platform_alert_dialog.dart';

import '../../widgets/form_submit_button.dart';

class EmailSignInFormBlocBased extends StatefulWidget
    with EmailAndPasswordValidators {
  final EmailSignInBloc bloc;

  EmailSignInFormBlocBased({@required this.bloc});

  static Widget create(BuildContext context) {
    final AuthBase auth = Provider.of<AuthBase>(context);
    return Provider<EmailSignInBloc>(
      create: (_) => EmailSignInBloc(auth: auth),
      child: Consumer<EmailSignInBloc>(
        builder: (context, bloc, _) => EmailSignInFormBlocBased(bloc: bloc),
      ),
      dispose: (context, bloc) => bloc.dispose(),
    );
  }

  @override
  _EmailSignInFormBlocBasedState createState() =>
      _EmailSignInFormBlocBasedState();
}

class _EmailSignInFormBlocBasedState extends State<EmailSignInFormBlocBased> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  String get _email => _emailController.text;
  String get _password => _passwordController.text;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EmailSignInModel>(
        stream: widget.bloc.emailSIStream,
        initialData: EmailSignInModel(),
        builder: (context, snapshot) {
          final EmailSignInModel emodel = snapshot.data;
          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: _buildChildren(emodel),
            ),
          );
        });
  }

  List<Widget> _buildChildren(EmailSignInModel emodel) {
    final primaryText = emodel.formType == EmailSignInFormType.signIn
        ? 'Sign In'
        : 'Create an account';
    final secondaryText = emodel.formType == EmailSignInFormType.signIn
        ? 'Need an account ? Register'
        : 'Have an account ? Sign in';
    bool submitEnable = widget.emailValidator.isValid(_email) &&
        widget.passwordValidator.isValid(_password) &&
        !emodel.isLoading;

    return [
      _buildEmailTextField(emodel),
      SizedBox(height: 8.0),
      _buildPasswordTextField(emodel),
      SizedBox(height: 8.0),
      FormSubmitButton(
        text: primaryText,
        onPressed: submitEnable ? _submit : null,
      ),
      SizedBox(height: 8.0),
      FlatButton(
        child: Text(secondaryText),
        onPressed: !emodel.isLoading ? () => _toggleFormType(emodel) : null,
      ),
    ];
  }

  TextField _buildEmailTextField(EmailSignInModel emodel) {
    bool showErrorText =
        emodel.submitted && !widget.emailValidator.isValid(_email);
    return TextField(
      controller: _emailController,
      focusNode: _emailFocus,
      decoration: InputDecoration(
        labelText: 'Email ',
        hintText: '@email.com',
        errorText: showErrorText ? widget.invalidEmailError : null,
        enabled: emodel.isLoading == false,
      ),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onChanged: (email) => widget.bloc.updateWith(email: email),
      onEditingComplete: () => _emailEditingComplete(emodel),
    );
  }

  void _emailEditingComplete(EmailSignInModel emodel) {
    final newFocus = widget.emailValidator.isValid(emodel.email)
        ? _passwordFocus
        : _emailFocus;
    FocusScope.of(context).requestFocus(newFocus);
  }

  TextField _buildPasswordTextField(EmailSignInModel emodel) {
    bool showErrorText =
        emodel.submitted && !widget.passwordValidator.isValid(_password);
    return TextField(
      controller: _passwordController,
      focusNode: _passwordFocus,
      decoration: InputDecoration(
        labelText: 'Password ',
        errorText: showErrorText ? widget.invalidPasswordError : null,
        enabled: emodel.isLoading == false,
      ),
      obscureText: true,
      textInputAction: TextInputAction.done,
      onChanged: (password) => widget.bloc.updateWith(password: password),
      onEditingComplete: _submit,
    );
  }

  Future<void> _submit() async {
    // print('submit call');
    try {
      // await Future.delayed(Duration(seconds: 5));
      await widget.bloc.submit();
      Navigator.of(context).pop();
    } catch (e) {
      PlatformAlertDialog(
        title:'Sign In Failed',
        content: e.toString(),
        defaultActionText: 'OK',
      ).show(context);
    }
  }

  void _toggleFormType(EmailSignInModel emodel) {
    final formType = emodel.formType == EmailSignInFormType.signIn
        ? EmailSignInFormType.register
        : EmailSignInFormType.signIn;
    widget.bloc.updateWith(
      email: '',
      password: '',
      formType: formType,
      isLoading: false,
      submitted: false,
    );
    _emailController.clear();
    _passwordController.clear();
  }
}
