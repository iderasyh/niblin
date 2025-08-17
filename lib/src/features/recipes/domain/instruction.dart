class Instruction {
  const Instruction({
    required this.stepNumber,
    required this.description,
    this.cookingActionIcon,
    this.babySpecificNote,
    this.estimatedTimeMinutes,
  });

  final int stepNumber;
  final String description;
  final String? cookingActionIcon; // Icon name or identifier
  final String? babySpecificNote; // Special note for baby feeding
  final int? estimatedTimeMinutes;

  Instruction copyWith({
    int? stepNumber,
    String? description,
    String? cookingActionIcon,
    String? babySpecificNote,
    int? estimatedTimeMinutes,
  }) {
    return Instruction(
      stepNumber: stepNumber ?? this.stepNumber,
      description: description ?? this.description,
      cookingActionIcon: cookingActionIcon ?? this.cookingActionIcon,
      babySpecificNote: babySpecificNote ?? this.babySpecificNote,
      estimatedTimeMinutes: estimatedTimeMinutes ?? this.estimatedTimeMinutes,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'stepNumber': stepNumber,
      'description': description,
      'cookingActionIcon': cookingActionIcon,
      'babySpecificNote': babySpecificNote,
      'estimatedTimeMinutes': estimatedTimeMinutes,
    };
  }

  factory Instruction.fromMap(Map<String, dynamic> map) {
    return Instruction(
      stepNumber: map['stepNumber'] as int? ?? 0,
      description: map['description'] as String? ?? '',
      cookingActionIcon: map['cookingActionIcon'] as String?,
      babySpecificNote: map['babySpecificNote'] as String?,
      estimatedTimeMinutes: map['estimatedTimeMinutes'] as int?,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Instruction &&
        other.stepNumber == stepNumber &&
        other.description == description &&
        other.cookingActionIcon == cookingActionIcon &&
        other.babySpecificNote == babySpecificNote &&
        other.estimatedTimeMinutes == estimatedTimeMinutes;
  }

  @override
  int get hashCode {
    return Object.hash(
      stepNumber,
      description,
      cookingActionIcon,
      babySpecificNote,
      estimatedTimeMinutes,
    );
  }

  @override
  String toString() {
    return 'Instruction(stepNumber: $stepNumber, description: $description, '
        'cookingActionIcon: $cookingActionIcon, babySpecificNote: $babySpecificNote, '
        'estimatedTimeMinutes: $estimatedTimeMinutes)';
  }
}