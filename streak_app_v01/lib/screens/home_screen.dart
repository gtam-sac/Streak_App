import 'package:flutter/material.dart';
import '../models/app_state.dart';
import '../services/storage_service.dart';
import '../widgets/flame_widget.dart';
import '../widgets/habit_card.dart';
import 'habits_screen.dart';
import 'completion_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.state,
    required this.storage,
  });

  final AppState state;
  final StorageService storage;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late AppState state;

  @override
  void initState() {
    super.initState();
    state = widget.state;
  }

  Future<void> _editHabits() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => HabitsScreen(state: state, storage: widget.storage),
      ),
    );
    final refreshed = await widget.storage.load();
    if (mounted) setState(() => state = refreshed);
  }

  Future<void> _completeToday() async {
    if (state.completedToday || !state.hasHabits) return;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CompletionScreen(state: state, storage: widget.storage),
      ),
    );
    final refreshed = await widget.storage.load();
    if (mounted) setState(() => state = refreshed);
  }

  @override
  Widget build(BuildContext context) {
    final dead = state.streak == 0 && state.lastCompletionDate != null;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Streak Flame',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
              onPressed: _editHabits, icon: const Icon(Icons.edit_outlined)),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
          children: [
            const SizedBox(height: 10),
            Center(child: FlameWidget(level: state.level, dead: dead)),
            const SizedBox(height: 12),
            Center(
              child: Text(
                '${state.streak} ${state.streak == 1 ? 'day' : 'days'}',
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
              ),
            ),
            Center(
              child: Text(
                state.level == 0 ? 'Start your flame' : 'Level ${state.level}',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Your habits',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                TextButton(onPressed: _editHabits, child: const Text('Edit')),
              ],
            ),
            if (state.habits.isEmpty)
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(14),
                ),
                child:
                    const Text('Add at least one habit to start your flame.'),
              )
            else
              ...state.habits.map((habit) =>
                  HabitCard(name: habit, completed: state.completedToday)),
            const SizedBox(height: 18),
            SizedBox(
              height: 54,
              child: FilledButton.icon(
                onPressed: state.completedToday || !state.hasHabits
                    ? null
                    : _completeToday,
                icon: Icon(state.completedToday
                    ? Icons.check
                    : Icons.local_fire_department),
                label: Text(state.completedToday
                    ? "Today's streak completed"
                    : "Complete Today's Streak"),
              ),
            ),
            if (!state.hasHabits) ...[
              const SizedBox(height: 10),
              OutlinedButton(
                  onPressed: _editHabits, child: const Text('Add habits')),
            ],
          ],
        ),
      ),
    );
  }
}
