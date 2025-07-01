class UserDetails {
  final String email;
  final String uid;

  UserDetails({required this.email, required this.uid});

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'uid': uid,
    };
  }

  factory UserDetails.fromMap(Map<String, dynamic> map) {
    return UserDetails(
      email: map['email'] ?? '',
      uid: map['uid'] ?? '',
    );
  }
}

