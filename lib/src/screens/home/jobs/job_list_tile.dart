
import 'package:flutter/material.dart';
import 'package:time_tracker/src/models/job.dart';

class JobListTile extends StatelessWidget{
  final Job job;
  final VoidCallback onTap;

  JobListTile({@required this.job,@required this.onTap});
  
  @override
  Widget build(BuildContext context){
    return ListTile( 
      title:Text(job.name),
      trailing:Icon(Icons.chevron_right),
      onTap:onTap,
    );
  }
}