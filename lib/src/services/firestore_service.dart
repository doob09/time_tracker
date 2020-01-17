import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirestoreService {
  static final instance = FirestoreService._();

  FirestoreService._();

//path to location is required set data into. Data is Map<String, dynamic>
  Future<void> setData(
      {@required String path, @required Map<String, dynamic> data}) async {
    final reference = Firestore.instance.document(path);
    print('$path:$data');
    await reference.setData(data);
  }

  Future<void> deleteData({@required String path}) async {
    final reference = Firestore.instance.document(path);
    print('delete: $path');
    await reference.delete();
  }

  //Generic StreamBuilder
  Stream<List<T>> collectionStream<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data, String documentID),
  }) {
    final reference = Firestore.instance.collection(path);
    final snapshots = reference.snapshots();
    print(reference.document);
    return snapshots.map(
      (snapshot) => snapshot.documents
          .map((snapshot) => builder(snapshot.data, snapshot.documentID))
          .toList(),
    );
  }
}
