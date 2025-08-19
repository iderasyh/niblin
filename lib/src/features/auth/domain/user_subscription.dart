enum SubscriptionStatus { free, premium, expired, canceled }

class UserSubscription {
  final SubscriptionStatus status;
  final DateTime? startedAt;
  final DateTime? endsAt;
  const UserSubscription({required this.status, this.startedAt, this.endsAt});

  UserSubscription copyWith({
    SubscriptionStatus? status,
    DateTime? startedAt,
    DateTime? endsAt,
  }) {
    return UserSubscription(
      status: status ?? this.status,
      startedAt: startedAt ?? this.startedAt,
      endsAt: endsAt ?? this.endsAt,
    );
  }

  const factory UserSubscription.none() = UserSubscription._none;

  const UserSubscription._none() : this(status: SubscriptionStatus.free);

  factory UserSubscription.fromMap(Map<String, dynamic> json) {
    return UserSubscription(
      status: SubscriptionStatus.values.firstWhere(
        (e) => e.name == json['status'],
      ),
      startedAt: DateTime.fromMillisecondsSinceEpoch(json['startedAt']),
      endsAt: DateTime.fromMillisecondsSinceEpoch(json['endsAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status.name,
      'startedAt': startedAt?.millisecondsSinceEpoch,
      'endsAt': endsAt?.millisecondsSinceEpoch,
    };
  }

  @override
  String toString() =>
      '''UserSubscription(status: $status, startedAt: $startedAt, endsAt: $endsAt)''';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserSubscription &&
        other.status == status &&
        other.startedAt == startedAt &&
        other.endsAt == endsAt;
  }

  @override
  int get hashCode => status.hashCode ^ startedAt.hashCode ^ endsAt.hashCode;
}
