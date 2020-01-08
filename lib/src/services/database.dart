
import 'package:flutter/foundation.dart';
import 'package:time_tracker/src/models/job.dart';
import 'package:time_tracker/src/services/api_path.dart';
import 'package:time_tracker/src/services/firestore_service.dart';

abstract class Database {
  Future<void> createJob(Job job);
  Stream<List<Job>> jobsStream();
}

class FireStoreDatabase implements Database {
  final String uid;
  final _service = FirestoreService.instance;


  FireStoreDatabase({@required this.uid}) : assert(uid != null);
// create data to database
  Future<void> createJob(Job job) async =>
      _service.setData(path: APIPath.job(uid, 'job_abc'), data: job.toMap());

  

// read data from database
  Stream<List<Job>> jobsStream() => _service.collectionStream(
        path: APIPath.jobs(uid),
        builder: (data) => Job.fromMap(data),
      );

  
}
