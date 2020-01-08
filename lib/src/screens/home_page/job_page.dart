import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:time_tracker/src/models/job.dart';
import 'package:time_tracker/src/services/auth.dart';
import 'package:time_tracker/src/services/database.dart';
import 'package:time_tracker/src/widgets/plat_form_exception_alert_dialog.dart';
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
      body: _buildContent(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _createJob(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context){
    final database = Provider.of<Database>(context);
    return StreamBuilder<List<Job>>(
      stream: database.jobsStream(),
      builder:(context, snapshot){
        if(snapshot.hasData){
          final jobs = snapshot.data;
          final children = jobs.map((job)=>Text(job.name)).toList();
          return ListView(children:children);
        }
        if(snapshot.hasError){
          return Center(child:Text('Error'));
        }
        return Center(child:CircularProgressIndicator());
      },
    );
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await PlatformAlertDialog(
      title: 'LogOut',
      content: 'Are you sure',
      cancelActionText: 'Cancel',
      defaultActionText: 'Logout',
    ).show(context);
    if (didRequestSignOut == true) {
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

  Future<void> _createJob(BuildContext context) async {
    try {
      final database = Provider.of<Database>(context);
      await database.createJob(Job(name: 'Blogging', ratePerHour: 10));
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }
  }
}
