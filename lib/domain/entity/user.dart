/// ユーザーエンティティ
class User {
  const User({
    required this.uid,
    required this.email,
    required this.username,
    this.bio,
    this.photoUrl,
    required this.createdAt,
  });

  final String uid;
  final String email;
  final String username;
  final String? bio;
  final String? photoUrl;
  final int createdAt;

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'bio': bio,
      'photoUrl': photoUrl,
      'createdAt': createdAt,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'] as String,
      email: map['email'] as String,
      username: map['username'] as String,
      bio: map['bio'] as String?,
      photoUrl: map['photoUrl'] as String?,
      createdAt: map['createdAt'] as int,
    );
  }
}
