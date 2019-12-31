import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:time_tracker/src/models/email_sign_in_model.dart';
// import 'package:time_tracker/src/screens/sign_in/validator.dart';
import 'package:time_tracker/src/services/auth.dart';
import 'package:time_tracker/src/services/email_sign_bloc.dart';
import 'package:time_tracker/src/widgets/plat_form_exception_alert_dialog.dart';
// import 'package:time_tracker/src/widgets/platform_alert_dialog.dart';

import '../../widgets/form_submit_button.dart';

class EmailSignInFormBlocBased extends StatefulWidget
     {
  
 
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

  final EmailSignInBloc bloc;

  EmailSignInFormBlocBased({@required this.bloc});


  @override
  _EmailSignInFormBlocBasedState createState() =>
      _EmailSignInFormBlocBasedState();
}

class _EmailSignInFormBlocBasedState extends State<EmailSignInFormBlocBased> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();



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
    
    return [
      _buildEmailTextField(emodel),
      SizedBox(height: 8.0),
      _buildPasswordTextField(emodel),
      SizedBox(height: 8.0),
      FormSubmitButton(
        text: emodel.primaryButtonText,
        onPressed: emodel.canSubmit ? _submit : null,
      ),
      SizedBox(height: 8.0),
      FlatButton(
        child: Text(emodel.secondaryButtonText),
        onPressed: !emodel.isLoading ?  _toggleFormType : null,
      ),
    ];
  }

  TextField _buildEmailTextField(EmailSignInModel emodel) {
    
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
      onChanged: widget.bloc.updateEmail,
      onEditingComplete: () => _emailEditingComplete(emodel),
    );
  }

  void _emailEditingComplete(EmailSignInModel emodel) {
    final newFocus = emodel.emailValidator.isValid(emodel.email)
        ? _passwordFocus
        : _emailFocus;
    FocusScope.of(context).requestFocus(newFocus);
  }

  TextField _buildPasswordTextField(EmailSignInModel emodel) {
    
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
      onChanged: widget.bloc.updatePassword,
      onEditingComplete: _submit,
    );
  }

  Future<void> _submit() async {
    
    try {
      
      await widget.bloc.submit();
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Sign In Failed',
        exception: e,
      ).show(context);
    }
  }

  void _toggleFormType() {
    widget.bloc.toggleFormType();
    _emailController.clear();
    _passwordController.clear();
  }
}
