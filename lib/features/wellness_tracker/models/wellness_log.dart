class WellnessLog {
  final DateTime date;
  final int sleepHours;
  final int waterIntake; // in glasses
  final int stressLevel; // 1-5 scale
  final int energyLevel; // 1-5 scale
  final int digestionQuality; // 1-5 scale
  final String? notes;

  WellnessLog({
    required this.date,
    required this.sleepHours,
    required this.waterIntake,
    required this.stressLevel,
    required this.energyLevel,
    required this.digestionQuality,
    this.notes,
  });

  // Convert to map for storage
  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'sleepHours': sleepHours,
      'waterIntake': waterIntake,
      'stressLevel': stressLevel,
      'energyLevel': energyLevel,
      'digestionQuality': digestionQuality,
      'notes': notes,
    };
  }

  // Create from map for retrieval
  factory WellnessLog.fromMap(Map<String, dynamic> map) {
    return WellnessLog(
      date: DateTime.parse(map['date']),
      sleepHours: map['sleepHours'],
      waterIntake: map['waterIntake'],
      stressLevel: map['stressLevel'],
      energyLevel: map['energyLevel'],
      digestionQuality: map['digestionQuality'],
      notes: map['notes'],
    );
  }
}