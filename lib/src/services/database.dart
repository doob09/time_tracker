import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:time_tracker/src/models/entry.dart';
import 'package:time_tracker/src/models/job.dart';
import 'package:time_tracker/src/services/api_path.dart';
import 'package:time_tracker/src/services/firestore_service.dart';

abstract class Database {
  Future<void> setJob(Job job);
  Stream<List<Job>> jobsStream();
  Future<void> deleteJob(Job job);

  Future<void> setEntry(Entry entry);
  Stream<List<Entry>> entriesStream();
}

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FireStoreDatabase implements Database {
  final String uid;
  final _service = FirestoreService.instance;

  FireStoreDatabase({@required this.uid}) : assert(uid != null);

// set Job data to database
  @override
  Future<void> setJob(Job job) async => _service.setData(// function setData from custom FirestoreService class requires 2 agurments 
        path: APIPath.job(uid, job.id), //provide uid, job. id form Job job to static function job of APIPath class 
        data: job.toMap(), // using toMap function from Job class to convert data into a Map
      );

// read data from database
  @override
  Stream<List<Job>> jobsStream() => _service.collectionStream(// using Generic StreamBuilder from FirestoreService class
        path: APIPath.jobs(uid),
        builder: (data, documentId) => Job.fromMap(documentId, data),
        
      );

  //delete data from database
  @override
  Future<void> deleteJob(Job job) async =>
      _service.deleteData(path: APIPath.job(uid, job.id));


  //set entry to database
  @override
  Future<void> setEntry(Entry entry) async => await _service.setData(
        path: APIPath.entry(uid, entry.id),
        data: entry.toMap(),// using toMap function from Entry class to convert data into a Map
      );
      
  @override
  Stream<List<Entry>> entriesStream() => _service.collectionStream(
    path: APIPath.entries(uid),
    builder:(documentId, data) => Entry.fromMap(documentId, data) 
  );
  
}
