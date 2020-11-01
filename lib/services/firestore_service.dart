import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:minimalist/services/auth_service.dart';

class FirestoreService {
  static final FirestoreService _singleton = FirestoreService._internal();

  FirestoreService._internal();

  final CollectionReference _statesCol = FirebaseFirestore.instance.collection("user_states");

  Future saveState(Map<String, dynamic> state) async {
    User user = AuthService().getUser();
    await _statesCol.doc(user.uid).set(state);
  }

  Future<Map<String, dynamic>> getState(User user) async {
    var doc = await _statesCol.doc(user.uid).get();
    return doc.data();
  }

  factory FirestoreService() {
    return _singleton;
  }
}
