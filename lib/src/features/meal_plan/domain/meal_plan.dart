// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../recipes/domain/category.dart' as recipe_category;

enum Days { monday, tuesday, wednesday, thursday, friday, saturday, sunday }

class MealPlan {
  final String id;
  final String uid;
  final String babyId;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String status;
  final Map<Days, Map<recipe_category.Category, String>>
  days; // Days -> Category -> Recipe ID
  MealPlan({
    required this.id,
    required this.uid,
    required this.babyId,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.days,
  });

  MealPlan copyWith({
    String? id,
    String? uid,
    String? babyId,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? status,
    Map<Days, Map<recipe_category.Category, String>>? days,
  }) {
    return MealPlan(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      babyId: babyId ?? this.babyId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      status: status ?? this.status,
      days: days ?? this.days,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'uid': uid,
      'babyId': babyId,
      'startDate': startDate.millisecondsSinceEpoch,
      'endDate': endDate.millisecondsSinceEpoch,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'status': status,
      'days': days.map(
        (day, meals) => MapEntry(
          day.name,
          meals.map(
            (category, recipeId) => MapEntry(category.name, recipeId),
          ),
        ),
      ),
    };
  }

  factory MealPlan.fromMap(Map<String, dynamic> map) {
    return MealPlan(
      id: map['id'] as String,
      uid: map['uid'] as String,
      babyId: map['babyId'] as String,
      startDate: DateTime.fromMillisecondsSinceEpoch(map['startDate'] as int),
      endDate: DateTime.fromMillisecondsSinceEpoch(map['endDate'] as int),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int),
      status: map['status'] as String,
      days: (map['days'] as Map<String, dynamic>).map(
        (dayString, mealsMap) => MapEntry(
          Days.values.byName(dayString),
          (mealsMap as Map<String, dynamic>).map(
            (categoryString, recipeId) => MapEntry(
              recipe_category.Category.values.byName(categoryString),
              recipeId as String,
            ),
          ),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory MealPlan.fromJson(String source) =>
      MealPlan.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MealPlan(id: $id, uid: $uid, babyId: $babyId, startDate: $startDate, endDate: $endDate, createdAt: $createdAt, updatedAt: $updatedAt, status: $status, days: $days)';
  }

  @override
  bool operator ==(covariant MealPlan other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.uid == uid &&
        other.babyId == babyId &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.status == status &&
        mapEquals(other.days, days);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        uid.hashCode ^
        babyId.hashCode ^
        startDate.hashCode ^
        endDate.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        status.hashCode ^
        days.hashCode;
  }
}
