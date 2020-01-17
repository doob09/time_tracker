import 'package:flutter/material.dart';
import 'package:time_tracker/src/models/entry.dart';
import 'package:time_tracker/src/models/job.dart';
import 'package:time_tracker/src/services/database.dart';
import 'package:time_tracker/src/widgets/date_time_picker.dart';

class EntryPage extends StatefulWidget {
  static Future<void> show(
      {BuildContext context, Database database, Entry entry, Job job}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            EntryPage(database: database, entry: entry, job: job),
        fullscreenDialog: true,
      ),
    );
  }

  final Entry entry;
  final Job job;
  final Database database;

  EntryPage(
      {@required this.entry, @required this.database, @required this.job});

  @override
  State<EntryPage> createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> {
  DateTime _startDate;
  DateTime _endDate;

  TimeOfDay _startTime;
  TimeOfDay _endTime;

  String _comment;

  @override
  void initState() {
    // state to show whent first launch the app
    super.initState();

    final start = widget.entry?.start ?? DateTime.now();
    _startDate = DateTime(start.year, start.month, start.day);
    _startTime = TimeOfDay.fromDateTime(start);

    final end = widget.entry?.end ?? DateTime.now();
    _endDate = DateTime(end.year, end.month, end.day);
    _endTime = TimeOfDay.fromDateTime(end);

    _comment = widget.entry?.comment ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.job.name),
        elevation: 2.0,
        actions: <Widget>[
          FlatButton(
            child: Text(
              widget.entry != null ? 'Edit' : 'Create',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            onPressed: () => _setEntryAndDismiss(context), // This button do submit change for the widget
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              _buildStartDate(),
              _buildEndDate(),
              SizedBox(height: 8.0),
              _buildDuration(), // will do later
              SizedBox(height: 8.0),
              _buildComments(),
            ],
          ),
        ),
      ),
    );
  }

  Entry _entryFromState(){
    final id = widget.entry ?.id ?? documentIdFromCurrentDate(); // set id for entry if null using current stime
    final start = DateTime(_startDate.year,_startDate.month, _startDate.day,_startTime.hour, _startTime.minute);
    final end  = DateTime(_endDate.year,_endDate.month, _endDate.day,_endTime.hour, _endTime.minute);
    return Entry(
      id :id ,
      jobId: widget.job.id,
      start: start,
      end: end,
      comment: _comment,
    );
  }

  Future<void> _setEntryAndDismiss(BuildContext context)async {
    final Entry entry = _entryFromState();
    await widget.database.setEntry( entry);
  }

  Widget _buildStartDate() {
    return DateTimePicker(
      labelText: 'Start',
      selectedDate: _startDate,
      onSelectedDate: (date) => setState(() => _startDate = date),
      selectedTime: _startTime,
      onSelectedTime: (time) => setState(() => _startTime = time),
    );
  }

  Widget _buildEndDate() {
    return DateTimePicker(
      labelText: 'End',
      selectedDate: _endDate,
      onSelectedDate: (date) => setState(() => _endDate = date),
      selectedTime: _endTime,
      onSelectedTime: (time) => setState(() => _endTime = time),
    );
  }

  Widget _buildDuration() {
    return Container();
  }

  Widget _buildComments() {
    return TextField(
      controller: TextEditingController(text: _comment), // show comment from database or leave it blank
      decoration: InputDecoration(
        labelText: 'Comment',
        labelStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
      ),
      keyboardType: TextInputType.text,
      maxLength: 50,
      maxLines: null,
      onChanged:(comment) => _comment = comment, // when state changed 
    );
  }
}
