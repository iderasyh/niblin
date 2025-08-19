import 'user_settings.dart';
import 'user_subscription.dart';

class User {
  const User({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.emailVerified = false,
    this.authProvider = const [],
    this.userSubscription = const UserSubscription.none(),
    this.userSettings = const UserSettings.initial(),
  });

  final String uid;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final bool emailVerified;
  final List<String> authProvider;
  final UserSubscription userSubscription;
  final UserSettings userSettings;

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'] as String,
      email: map['email'] as String,
      displayName: map['displayName'] as String?,
      photoUrl: map['photoUrl'] as String?,
      emailVerified: map['emailVerified'] as bool? ?? false,
      authProvider: map['authProvider'] as List<String>,
      userSubscription: UserSubscription.fromMap(
        map['userSubscription'] as Map<String, dynamic>? ?? {},
      ),
      userSettings: UserSettings.fromMap(
        map['userSettings'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'emailVerified': emailVerified,
      'authProvider': authProvider,
      'userSubscription': userSubscription.toMap(),
      'userSettings': userSettings.toMap(),
    };
  }

  User copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoUrl,
    bool? emailVerified,
    List<String>? authProvider,
    UserSubscription? userSubscription,
    UserSettings? userSettings,
  }) {
    return User(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      emailVerified: emailVerified ?? this.emailVerified,
      authProvider: authProvider ?? this.authProvider,
      userSubscription: userSubscription ?? this.userSubscription,
      userSettings: userSettings ?? this.userSettings,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User &&
        other.uid == uid &&
        other.email == email &&
        other.displayName == displayName &&
        other.photoUrl == photoUrl &&
        other.emailVerified == emailVerified &&
        other.authProvider == authProvider &&
        other.userSettings == userSettings &&
        other.userSubscription == userSubscription;
  }

  @override
  int get hashCode {
    return Object.hash(
      uid,
      email,
      displayName,
      photoUrl,
      emailVerified,
      authProvider,
      userSubscription,
      userSettings,
    );
  }

  @override
  String toString() {
    return 'User(uid: $uid, email: $email, displayName: $displayName, photoUrl: $photoUrl, emailVerified: $emailVerified, authProvider: $authProvider, userSubscription: $userSubscription, userSettings: $userSettings)';
  }
}
