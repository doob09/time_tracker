import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/src/models/entry.dart';
import 'package:time_tracker/src/models/job.dart';
import 'package:time_tracker/src/screens/home/jobs/edit_job_page.dart';
import 'package:time_tracker/src/services/database.dart';

import 'entry_page.dart';

class JobEntriesPage extends StatelessWidget {
  static Future<void> show(BuildContext context, Job job) async {
    final Database database = Provider.of<Database>(context);
    await Navigator.of(context).push(MaterialPageRoute(
      fullscreenDialog: false,
      builder: (context) => JobEntriesPage(database: database, job: job),
    ));
  }

  final Database database;
  final Job job;

  JobEntriesPage({@required this.database, @required this.job});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(job.name),
        elevation: 2.0,
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Edit',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
            onPressed:()=> EditJobPage.show(context, database: database,  job: job),
          ),
        ],
      ),
      body: _buildEntryList(context, job), // show all entry from database 
      floatingActionButton:FloatingActionButton(
        child:Icon(Icons.add),
        onPressed:()=> EntryPage.show(context:context, database: database, job: job),
      ),
    );
  }

 
  Widget _buildEntryList (BuildContext context, Job job){
    return StreamBuilder<List<Entry>>(
      stream: database.entriesStream(), // need to pass job to stream   >> ?????
      builder: // ,
    );

  }
}
