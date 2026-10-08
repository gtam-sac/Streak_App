import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_state.dart';

class StorageService {
  static const _habitsKey = 'habits';
  static const _streakKey = 'streak';
  static const _lastDateKey = 'lastCompletionDate';
  static const _summariesKey = 'summaries';

  Future<AppState> load() async {
    final prefs = await SharedPreferences.getInstance();
    final habits = prefs.getStringList(_habitsKey) ?? <String>[];
    final streak = prefs.getInt(_streakKey) ?? 0;
    final dateString = prefs.getString(_lastDateKey);
    final lastDate = dateString == null ? null : DateTime.tryParse(dateString);
    final rawSummaries = prefs.getString(_summariesKey);

    List<Map<String, dynamic>> summaries = [];
    if (rawSummaries != null) {
      try {
        final decoded = jsonDecode(rawSummaries) as List<dynamic>;
        summaries = decoded
            .map((item) => Map<String, dynamic>.from(item as Map))
            .toList();
      } catch (_) {
        summaries = [];
      }
    }

    return AppState(
      habits: habits,
      streak: streak,
      lastCompletionDate: lastDate,
      summaries: summaries,
    );
  }

  Future<void> save(AppState state) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_habitsKey, state.habits);
    await prefs.setInt(_streakKey, state.streak);

    if (state.lastCompletionDate == null) {
      await prefs.remove(_lastDateKey);
    } else {
      await prefs.setString(
        _lastDateKey,
        _dateOnly(state.lastCompletionDate!),
      );
    }

    await prefs.setString(_summariesKey, jsonEncode(state.summaries));
  }

  String _dateOnly(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}
