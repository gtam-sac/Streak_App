import 'package:flutter/material.dart';
import '../models/app_state.dart';
import '../services/storage_service.dart';

class HabitsScreen extends StatefulWidget {
  const HabitsScreen({super.key, required this.state, required this.storage});

  final AppState state;
  final StorageService storage;

  @override
  State<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
  late final TextEditingController _habit1;
  late final TextEditingController _habit2;

  @override
  void initState() {
    super.initState();
    _habit1 = TextEditingController(
        text: widget.state.habits.isNotEmpty ? widget.state.habits[0] : '');
    _habit2 = TextEditingController(
        text: widget.state.habits.length > 1 ? widget.state.habits[1] : '');
  }

  @override
  void dispose() {
    _habit1.dispose();
    _habit2.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final habits = [_habit1.text.trim(), _habit2.text.trim()]
        .where((name) => name.isNotEmpty)
        .take(2)
        .toList();
    widget.state.habits = habits;
    await widget.storage.save(widget.state);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Habits')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'You can have up to 2 habits.',
            style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _habit1,
            maxLength: 40,
            decoration: const InputDecoration(
                labelText: 'Habit 1', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _habit2,
            maxLength: 40,
            decoration: const InputDecoration(
                labelText: 'Habit 2 (optional)', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 18),
          SizedBox(
              height: 52,
              child: FilledButton(onPressed: _save, child: const Text('Save'))),
        ],
      ),
    );
  }
}
