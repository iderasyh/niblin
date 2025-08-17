const Object _undefined = Object();

class UserRecipeData {
  const UserRecipeData({
    required this.userId,
    required this.recipeId,
    this.isFavorite = false,
    this.hasTried = false,
    this.personalNotes,
    this.lastViewed,
    this.triedDate,
    this.isInMealPlan = false,
    this.mealPlanDate,
    this.viewCount = 0,
  });

  final String userId;
  final String recipeId;
  final bool isFavorite;
  final bool hasTried;
  final String? personalNotes;
  final DateTime? lastViewed;
  final DateTime? triedDate;
  final bool isInMealPlan;
  final DateTime? mealPlanDate;
  final int viewCount;

  UserRecipeData copyWith({
    String? userId,
    String? recipeId,
    bool? isFavorite,
    bool? hasTried,
    Object? personalNotes = _undefined,
    Object? lastViewed = _undefined,
    Object? triedDate = _undefined,
    bool? isInMealPlan,
    Object? mealPlanDate = _undefined,
    int? viewCount,
  }) {
    return UserRecipeData(
      userId: userId ?? this.userId,
      recipeId: recipeId ?? this.recipeId,
      isFavorite: isFavorite ?? this.isFavorite,
      hasTried: hasTried ?? this.hasTried,
      personalNotes: personalNotes == _undefined ? this.personalNotes : personalNotes as String?,
      lastViewed: lastViewed == _undefined ? this.lastViewed : lastViewed as DateTime?,
      triedDate: triedDate == _undefined ? this.triedDate : triedDate as DateTime?,
      isInMealPlan: isInMealPlan ?? this.isInMealPlan,
      mealPlanDate: mealPlanDate == _undefined ? this.mealPlanDate : mealPlanDate as DateTime?,
      viewCount: viewCount ?? this.viewCount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'recipeId': recipeId,
      'isFavorite': isFavorite,
      'hasTried': hasTried,
      'personalNotes': personalNotes,
      'lastViewed': lastViewed?.toIso8601String(),
      'triedDate': triedDate?.toIso8601String(),
      'isInMealPlan': isInMealPlan,
      'mealPlanDate': mealPlanDate?.toIso8601String(),
      'viewCount': viewCount,
    };
  }

  factory UserRecipeData.fromMap(Map<String, dynamic> map) {
    return UserRecipeData(
      userId: map['userId'] as String? ?? '',
      recipeId: map['recipeId'] as String? ?? '',
      isFavorite: map['isFavorite'] as bool? ?? false,
      hasTried: map['hasTried'] as bool? ?? false,
      personalNotes: map['personalNotes'] as String?,
      lastViewed: map['lastViewed'] != null 
          ? DateTime.parse(map['lastViewed'] as String)
          : null,
      triedDate: map['triedDate'] != null 
          ? DateTime.parse(map['triedDate'] as String)
          : null,
      isInMealPlan: map['isInMealPlan'] as bool? ?? false,
      mealPlanDate: map['mealPlanDate'] != null 
          ? DateTime.parse(map['mealPlanDate'] as String)
          : null,
      viewCount: map['viewCount'] as int? ?? 0,
    );
  }

  /// Increment view count and update last viewed timestamp
  UserRecipeData incrementViewCount() {
    return copyWith(
      viewCount: viewCount + 1,
      lastViewed: DateTime.now(),
    );
  }

  /// Mark recipe as tried with current timestamp
  UserRecipeData markAsTried() {
    return copyWith(
      hasTried: true,
      triedDate: DateTime.now(),
    );
  }

  /// Toggle favorite status
  UserRecipeData toggleFavorite() {
    return copyWith(isFavorite: !isFavorite);
  }

  /// Add to meal plan for specific date
  UserRecipeData addToMealPlan(DateTime date) {
    return copyWith(
      isInMealPlan: true,
      mealPlanDate: date,
    );
  }

  /// Remove from meal plan
  UserRecipeData removeFromMealPlan() {
    return copyWith(
      isInMealPlan: false,
      mealPlanDate: null,
    );
  }

  /// Update personal notes
  UserRecipeData updateNotes(String? notes) {
    return copyWith(personalNotes: notes);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserRecipeData &&
        other.userId == userId &&
        other.recipeId == recipeId &&
        other.isFavorite == isFavorite &&
        other.hasTried == hasTried &&
        other.personalNotes == personalNotes &&
        other.lastViewed == lastViewed &&
        other.triedDate == triedDate &&
        other.isInMealPlan == isInMealPlan &&
        other.mealPlanDate == mealPlanDate &&
        other.viewCount == viewCount;
  }

  @override
  int get hashCode {
    return Object.hash(
      userId,
      recipeId,
      isFavorite,
      hasTried,
      personalNotes,
      lastViewed,
      triedDate,
      isInMealPlan,
      mealPlanDate,
      viewCount,
    );
  }

  @override
  String toString() {
    return 'UserRecipeData(userId: $userId, recipeId: $recipeId, '
        'isFavorite: $isFavorite, hasTried: $hasTried, '
        'personalNotes: $personalNotes, lastViewed: $lastViewed, '
        'triedDate: $triedDate, isInMealPlan: $isInMealPlan, '
        'mealPlanDate: $mealPlanDate, viewCount: $viewCount)';
  }
}