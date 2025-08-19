import 'dart:convert';

import '../../../../l10n/app_localizations.dart';
import '../../../routing/app_router.dart';

enum TipContentType { tip, article, reminder, milestone, safety }

enum TipCategory { feeding, safety, development, sleep, general, other }

class TipContent {
  const TipContent({
    required this.id,
    required this.title,
    required this.description,
    required this.contentType,
    required this.targetAgeMinMonths,
    required this.targetAgeMaxMonths,
    required this.category,
    required this.priority,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String title;
  final String description;
  final TipContentType contentType;
  final int targetAgeMinMonths; // Minimum age in months
  final int targetAgeMaxMonths; // Maximum age in months
  final TipCategory category; // e.g., "feeding", "safety", "development"
  final int priority; // Higher number = higher priority for display (1-5)
  final String? imageUrl; // Optional image for the tip
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Check if this tip is appropriate for a baby of given age in months
  bool isAppropriateForAge(int babyAgeInMonths) {
    return babyAgeInMonths >= targetAgeMinMonths &&
        babyAgeInMonths <= targetAgeMaxMonths;
  }

  /// Get display text based on content type
  String get typeDisplayText {
    final localization = AppLocalizations.of(rootNavigatorKey.currentContext!)!;
    switch (contentType) {
      case TipContentType.tip:
        return localization.tip;
      case TipContentType.article:
        return localization.article;
      case TipContentType.reminder:
        return localization.reminder;
      case TipContentType.milestone:
        return localization.milestone;
      case TipContentType.safety:
        return localization.safety;
    }
  }

  /// Get appropriate icon based on content type
  String get typeIcon {
    switch (contentType) {
      case TipContentType.tip:
        return '💡';
      case TipContentType.article:
        return '📖';
      case TipContentType.reminder:
        return '⏰';
      case TipContentType.milestone:
        return '🎯';
      case TipContentType.safety:
        return '🛡️';
    }
  }

  TipContent copyWith({
    String? id,
    String? title,
    String? description,
    TipContentType? contentType,
    int? targetAgeMinMonths,
    int? targetAgeMaxMonths,
    TipCategory? category,
    int? priority,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TipContent(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      contentType: contentType ?? this.contentType,
      targetAgeMinMonths: targetAgeMinMonths ?? this.targetAgeMinMonths,
      targetAgeMaxMonths: targetAgeMaxMonths ?? this.targetAgeMaxMonths,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'contentType': contentType.name,
      'targetAgeMinMonths': targetAgeMinMonths,
      'targetAgeMaxMonths': targetAgeMaxMonths,
      'category': category.name,
      'priority': priority,
      'imageUrl': imageUrl,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory TipContent.fromMap(Map<String, dynamic> map) {
    return TipContent(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      contentType: TipContentType.values.firstWhere(
        (type) => type.name == (map['contentType'] as String),
        orElse: () => TipContentType.tip,
      ),
      targetAgeMinMonths: map['targetAgeMinMonths'] as int,
      targetAgeMaxMonths: map['targetAgeMaxMonths'] as int,
      category: TipCategory.values.firstWhere(
        (category) => category.name == (map['category'] as String),
        orElse: () => TipCategory.other,
      ),
      priority: map['priority'] as int,
      imageUrl: map['imageUrl'] as String?,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory TipContent.fromJson(String source) =>
      TipContent.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TipContent(id: $id, title: $title, description: $description, contentType: $contentType, targetAgeMinMonths: $targetAgeMinMonths, targetAgeMaxMonths: $targetAgeMaxMonths, category: $category, priority: $priority, imageUrl: $imageUrl, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant TipContent other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.description == description &&
        other.contentType == contentType &&
        other.targetAgeMinMonths == targetAgeMinMonths &&
        other.targetAgeMaxMonths == targetAgeMaxMonths &&
        other.category == category &&
        other.priority == priority &&
        other.imageUrl == imageUrl &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        contentType.hashCode ^
        targetAgeMinMonths.hashCode ^
        targetAgeMaxMonths.hashCode ^
        category.hashCode ^
        priority.hashCode ^
        imageUrl.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
