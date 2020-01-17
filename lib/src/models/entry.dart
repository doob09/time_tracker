import 'package:flutter/material.dart';

class Entry {
  String id;
  String jobId;
  DateTime start;
  DateTime end;
  String comment;


  Entry({
    this.id,
    this.jobId,
    this.start,
    this.end,
    this.comment,
  });

  factory Entry.fromMap( String documentId, Map<String,dynamic> data,){
    if(data ==null){
      return null;
    }
    final start = data['start'];
    final end = data['end'];
    final comment = data['comment'];
    return Entry(
      id:documentId,
      start:start,
      end: end,
      comment: comment,
    );
  }

//using toMap Function to map data argument passing from job_entries_page 
  Map<String, dynamic> toMap(){ 
    return <String, dynamic>{
      
      'jobId': jobId,
      'start': start,
      'end': end,
      'comment': comment,
    };
  }
}
