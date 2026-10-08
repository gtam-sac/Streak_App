class AppState {
  AppState({
    required this.habits,
    required this.streak,
    required this.lastCompletionDate,
    required this.summaries,
  });

  List<String> habits;
  int streak;
  DateTime? lastCompletionDate;
  List<Map<String, dynamic>> summaries;

  int get level {
    if (streak >= 30) return 4;
    if (streak >= 14) return 3;
    if (streak >= 7) return 2;
    if (streak >= 1) return 1;
    return 0;
  }

  bool get completedToday {
    final last = lastCompletionDate;
    if (last == null) return false;
    final now = DateTime.now();
    return last.year == now.year &&
        last.month == now.month &&
        last.day == now.day;
  }

  bool get hasHabits => habits.isNotEmpty;
}
