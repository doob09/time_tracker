import 'package:flutter/material.dart';

import 'package:time_tracker/src/models/job.dart';
import 'package:time_tracker/src/services/database.dart';
import 'package:time_tracker/src/widgets/plat_form_exception_alert_dialog.dart';
import 'package:flutter/services.dart';
import 'package:time_tracker/src/widgets/platform_alert_dialog.dart';

class EditJobPage extends StatefulWidget {
  static Future<void> show(BuildContext context,{Database database,Job job}) async {
    //final database = Provider.of<Database>(context);
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditJobPage(database: database, job:job),
        fullscreenDialog: true,
      ),
    );
  }

  final Database database;
  final Job job;

  const EditJobPage({Key key, @required this.database,@required this.job}) : super(key: key);
  
  @override
  _EditJobPageState createState() => _EditJobPageState();
}

class _EditJobPageState extends State<EditJobPage> {
  String _name;
  int _ratePerHour;
  final _formKey = GlobalKey<FormState>();

  @override 
  void initState(){
    super.initState();
    if(widget.job != null ){
      _name = widget.job.name;
      _ratePerHour = widget.job.ratePerHour;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.job == null ? 'New Job' : 'Edit Job'),
        elevation: 2.0,
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Save',
              style: TextStyle(fontSize: 18.0, color: Colors.white),
            ),
            onPressed: _submit,
          ),
        ],
      ),
      body: _buildContent(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        decoration: InputDecoration(labelText: 'Job name'),
        initialValue: _name,
        validator: (value) => value.isNotEmpty ? null : 'Name can\'t  be empty',
        onSaved: (value) => _name = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Rate per hour'),
        initialValue:_ratePerHour !=null ?  '$_ratePerHour' : null,
        keyboardType:
            TextInputType.numberWithOptions(signed: false, decimal: false),
        onSaved: (value) => _ratePerHour = int.tryParse(value) ?? 0,
      )
    ];
  }

  Future<void> _submit() async { // check 4 states 
    if (_validateAndSaveForm()) {
      try {
        final jobs = await widget.database.jobsStream().first;
        final allNames = jobs.map((job) => job.name).toList();
        if(widget.job !=null){
          allNames.remove(widget.job.name);
        }
        if (allNames.contains(_name)) {
          PlatformAlertDialog(
            title: 'Name is already used',
            content: 'Please choos different job name',
            defaultActionText: 'OK',
          ).show(context);
        } else {
          final id = widget.job ?.id ?? documentIdFromCurrentDate();  // check job id  from firestore
          final job = Job(id: id, name: _name, ratePerHour: _ratePerHour);
          await widget.database.setJob(job);
          Navigator.of(context).pop();
        }
      } on PlatformException catch (e) {
        PlatformExceptionAlertDialog(
          title: 'Operation failed',
          exception: e,
        ).show(context);
      }
    }
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
