import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:time_tracker/src/models/email_sign_in_change_model.dart';
import 'package:time_tracker/src/models/email_sign_in_model.dart';
// import 'package:time_tracker/src/screens/sign_in/validator.dart';
import 'package:time_tracker/src/services/auth.dart';

import 'package:time_tracker/src/widgets/plat_form_exception_alert_dialog.dart';
// import 'package:time_tracker/src/widgets/platform_alert_dialog.dart';

import '../../widgets/form_submit_button.dart';

class EmailSignInChangeNotifier extends StatefulWidget {
  
  
  static Widget create(BuildContext context) {
    final AuthBase auth = Provider.of<AuthBase>(context);
    return ChangeNotifierProvider<EmailSignInChangeModel>(
      create: (_) => EmailSignInChangeModel(auth: auth),
      child: Consumer<EmailSignInChangeModel>(
        builder: (context, model, _) => EmailSignInChangeNotifier(model: model),
      ),
      
    );
  }

  final EmailSignInChangeModel model;

  EmailSignInChangeNotifier({@required this.model});

  @override
  _EmailSignInChangeNotifierState createState() =>
      _EmailSignInChangeNotifierState();
}

class _EmailSignInChangeNotifierState extends State<EmailSignInChangeNotifier> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  EmailSignInChangeModel get emodel => widget.model;

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
    
          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: _buildChildren(),
            ),
          );
        
  }

  List<Widget> _buildChildren() {
    return [
      _buildEmailTextField(),
      SizedBox(height: 8.0),
      _buildPasswordTextField(),
      SizedBox(height: 8.0),
      FormSubmitButton(
        text: emodel.primaryButtonText,
        onPressed: emodel.canSubmit ? _submit : null,
      ),
      SizedBox(height: 8.0),
      FlatButton(
        child: Text(emodel.secondaryButtonText),
        onPressed: !emodel.isLoading ? _toggleFormType : null,
      ),
    ];
  }

  TextField _buildEmailTextField() {
    return TextField(
      controller: _emailController,
      focusNode: _emailFocus,
      decoration: InputDecoration(
        labelText: 'Email ',
        hintText: '@email.com',
        errorText: emodel.invalidEmailError,
        enabled: emodel.isLoading == false,
      ),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onChanged: emodel.updateEmail,
      onEditingComplete: () => _emailEditingComplete(),
    );
  }

  void _emailEditingComplete() {
    final newFocus = emodel.emailValidator.isValid(emodel.email)
        ? _passwordFocus
        : _emailFocus;
    FocusScope.of(context).requestFocus(newFocus);
  }

  TextField _buildPasswordTextField() {
    return TextField(
      controller: _passwordController,
      focusNode: _passwordFocus,
      decoration: InputDecoration(
        labelText: 'Password ',
        errorText: emodel.passwordErrorText,
        enabled: emodel.isLoading == false,
      ),
      obscureText: true,
      textInputAction: TextInputAction.done,
      onChanged: emodel.updatePassword,
      onEditingComplete: _submit,
    );
  }

  Future<void> _submit() async {
    try {
      await emodel.submit();
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Sign In Failed',
        exception: e,
      ).show(context);
    }
  }

  void _toggleFormType() {
    emodel.toggleFormType();
    _emailController.clear();
    _passwordController.clear();
  }
}
