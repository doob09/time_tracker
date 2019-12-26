import 'package:flutter/material.dart';
import '../../widgets/form_submit_button.dart';

class EmailSignInFormStateful extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: buildChildren(),
      ),
    );
  }

  List<Widget> buildChildren() {
    return [
      TextField(
        controller: _emailController,
        decoration: InputDecoration(
          labelText: 'Email ',
          hintText: '@email.com',
        ),
        onChanged: (value) => print(value),
      ),
      SizedBox(height: 8.0),
      TextField(
        controller: _passwordController,
        decoration: InputDecoration(
          labelText: 'Password ',
        ),
        obscureText: true,
      ),
      SizedBox(height: 8.0),
      FormSubmitButton(
        text: 'Sign In',
        onPressed: _submit,
      ),
      SizedBox(height: 8.0),
      FlatButton(
        child: Text('Need an account ? Register'),
        onPressed: () {},
      ),
    ];
  }

  void _submit() {
    print(
        'Emiail: ${_emailController.text} , Password: ${_passwordController.text}');
  }
}
