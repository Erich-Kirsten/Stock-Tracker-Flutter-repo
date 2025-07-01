import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_details.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveUserData(UserDetails user) async {
    try {
      await _firestore.collection('users').doc(user.uid).set(user.toMap());
    } catch (e) {
      print('Error saving user data: $e');
    }
  }

  Future<UserDetails?> getUserData(String uid) async {
    try {
      DocumentSnapshot snapshot = await _firestore.collection('users').doc(uid).get();
      if (snapshot.exists) {
        return UserDetails.fromMap(snapshot.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print('Error getting user data: $e');
    }
    return null;
  }
}
