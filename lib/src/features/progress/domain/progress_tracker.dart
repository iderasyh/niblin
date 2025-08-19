import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../routing/app_router.dart';

class ProgressTracker {
  const ProgressTracker({
    required this.id,
    required this.userId,
    required this.babyId,
    required this.weekStartDate,
    required this.weekEndDate,
    required this.newFoodsIntroduced,
    required this.totalMealsLogged,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String userId;
  final String babyId;
  final DateTime weekStartDate;
  final DateTime weekEndDate;
  final List<String>
  newFoodsIntroduced; // List of food ids introduced this week
  final int totalMealsLogged;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Get encouraging message based on progress
  String get encouragingMessage {
    final localization = AppLocalizations.of(rootNavigatorKey.currentContext!)!;
    final foodCount = newFoodsIntroduced.length;
    if (foodCount == 0) {
      return localization.readyToExploreNewFlavorsThisWeek;
    } else if (foodCount == 1) {
      return localization.youveIntroducedOneNewFoodThisWeek;
    } else {
      return localization.youveIntroducedNewFoodsThisWeek(foodCount);
    }
  }

  /// Get emoji representation of introduced foods (max 5 emojis)
  List<String> get foodEmojis {
    final emojiMap = {
      // Fruits (soft, mashable)
      'avocado': '🥑',
      'banana': '🍌',
      'apple': '🍎', // cooked/mashed, not raw slices
      'pear': '🍐',
      'peach': '🍑',
      'mango': '🥭',
      'strawberry': '🍓',
      'blueberry': '🫐', // mashed or cut
      'melon': '🍈',
      'watermelon': '🍉',
      'plum': '🍑', // same emoji
      'orange': '🍊', // segments or mashed
      'kiwi': '🥝',
      'coconut': '🥥', // yogurt/milk products, not chunks

      // Vegetables
      'carrot': '🥕', // steamed & mashed
      'sweetPotato': '🍠',
      'pumpkin': '🎃',
      'potato': '🥔',
      'broccoli': '🥦', // well-cooked florets
      'spinach': '🥬',
      'zucchini': '🥒', // cooked, peeled
      'tomato': '🍅',
      'corn': '🌽', // mashed, not whole kernels
      'peas': '🫘', // new bean emoji (mashed)
      'butternutSquash': '🎃',

      // Proteins (age-appropriate portions)
      'egg': '🥚', // scrambled/boiled, not raw
      'fish': '🐟', // well-cooked, deboned
      'poultry': '🍗', // shredded chicken/turkey
      'meat': '🥩', // finely ground, cooked
      'tofu': '🧆', // falafel emoji used as tofu/legumes
      // Grains / Carbs
      'bread': '🍞', // soft, small pieces
      'rice': '🍚',
      'pasta': '🍝', // small, soft pasta
      'oatmeal': '🥣', // porridge bowl emoji
      'pancakes': '🥞', // no sugar/syrup
      // Dairy (if no allergy)
      'cheese': '🧀',
      'yogurt': '🥛', // using milk emoji for yogurt
      'butter': '🧈',

      // Healthy Extras
      'oliveOil': '🫒',
    };

    return newFoodsIntroduced
        .take(5) // Limit to 5 emojis for clean display
        .map((food) => emojiMap[food.toLowerCase()] ?? '🍽️')
        .toList();
  }

  ProgressTracker copyWith({
    String? id,
    String? userId,
    String? babyId,
    DateTime? weekStartDate,
    DateTime? weekEndDate,
    List<String>? newFoodsIntroduced,
    int? totalMealsLogged,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProgressTracker(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      babyId: babyId ?? this.babyId,
      weekStartDate: weekStartDate ?? this.weekStartDate,
      weekEndDate: weekEndDate ?? this.weekEndDate,
      newFoodsIntroduced: newFoodsIntroduced ?? this.newFoodsIntroduced,
      totalMealsLogged: totalMealsLogged ?? this.totalMealsLogged,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'babyId': babyId,
      'weekStartDate': weekStartDate.millisecondsSinceEpoch,
      'weekEndDate': weekEndDate.millisecondsSinceEpoch,
      'newFoodsIntroduced': newFoodsIntroduced,
      'totalMealsLogged': totalMealsLogged,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory ProgressTracker.fromMap(Map<String, dynamic> map) {
    return ProgressTracker(
      id: map['id'] as String,
      userId: map['userId'] as String,
      babyId: map['babyId'] as String,
      weekStartDate: DateTime.fromMillisecondsSinceEpoch(
        map['weekStartDate'] as int,
      ),
      weekEndDate: DateTime.fromMillisecondsSinceEpoch(
        map['weekEndDate'] as int,
      ),
      newFoodsIntroduced: List<String>.from(
        map['newFoodsIntroduced'] as List<dynamic>,
      ),
      totalMealsLogged: map['totalMealsLogged'] as int,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory ProgressTracker.fromJson(String source) =>
      ProgressTracker.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProgressTracker(id: $id, userId: $userId, babyId: $babyId, weekStartDate: $weekStartDate, weekEndDate: $weekEndDate, newFoodsIntroduced: $newFoodsIntroduced, totalMealsLogged: $totalMealsLogged, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant ProgressTracker other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userId == userId &&
        other.babyId == babyId &&
        other.weekStartDate == weekStartDate &&
        other.weekEndDate == weekEndDate &&
        listEquals(other.newFoodsIntroduced, newFoodsIntroduced) &&
        other.totalMealsLogged == totalMealsLogged &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        babyId.hashCode ^
        weekStartDate.hashCode ^
        weekEndDate.hashCode ^
        newFoodsIntroduced.hashCode ^
        totalMealsLogged.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
