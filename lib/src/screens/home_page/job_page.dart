import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/src/services/auth.dart';
import 'package:time_tracker/src/widgets/platform_alert_dialog.dart';

class JobsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jobs'),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Sign Out',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
            onPressed: () => _confirmSignOut(context),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmSignOut (BuildContext context ) async {
    final didRequestSignOut = await PlatformAlertDialog( 
      title: 'LogOut',
      content: 'Are you sure',
      cancelActionText: 'Cancel',
      defaultActionText:'hoho',
    ).show(context);
    if(didRequestSignOut == true ){
      _signOut(context);
    }
  }
  Future<void> _signOut(context) async {
    try {
      final auth = Provider.of<AuthBase>(context);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}
