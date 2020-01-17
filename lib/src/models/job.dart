import 'package:flutter/foundation.dart';

class Job {
  final String id;
  final String name;
  final int ratePerHour;

  factory Job.fromMap(Map<String, dynamic> data,String  documentId) {
    if (data == null) {
      return null;
    }
    final String name = data['name'];
    final int ratePerHour = data['ratePerHour'];
    return Job(
      id: documentId,
      name: name,
      ratePerHour: ratePerHour,
    );
  }
  
  Job({@required this.id, @required this.name, @required this.ratePerHour});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'rateHour': ratePerHour,
    };
  }
}
