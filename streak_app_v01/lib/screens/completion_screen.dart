import 'package:flutter/material.dart';
import '../models/app_state.dart';
import '../services/storage_service.dart';

class CompletionScreen extends StatefulWidget {
  const CompletionScreen({super.key, required this.state, required this.storage});

  final AppState state;
  final StorageService storage;

  @override
  State<CompletionScreen> createState() => _CompletionScreenState();
}

class _CompletionScreenState extends State<CompletionScreen> {
  late List<bool> _completed;
  final _summaryController = TextEditingController();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _completed = List<bool>.filled(widget.state.habits.length, false);
  }

  @override
  void dispose() {
    _summaryController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final summary = _summaryController.text.trim();
    if (_completed.any((value) => !value)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Complete all your habits first.')),
      );
      return;
    }
    if (summary.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add a one-sentence summary.')),
      );
      return;
    }

    setState(() => _saving = true);
    final now = DateTime.now();
    widget.state.streak += 1;
    widget.state.lastCompletionDate = DateTime(now.year, now.month, now.day);
    widget.state.summaries.add({
      'date': widget.state.lastCompletionDate!.toIso8601String(),
      'summary': summary,
      'habits': List<String>.from(widget.state.habits),
    });
    await widget.storage.save(widget.state);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Complete Today')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('What did you accomplish today?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ...List.generate(widget.state.habits.length, (index) {
            return CheckboxListTile(
              value: _completed[index],
              onChanged: (value) => setState(() => _completed[index] = value ?? false),
              title: Text(widget.state.habits[index]),
              contentPadding: EdgeInsets.zero,
            );
          }),
          const SizedBox(height: 18),
          TextField(
            controller: _summaryController,
            minLines: 3,
            maxLines: 5,
            maxLength: 160,
            decoration: const InputDecoration(
              labelText: 'One-sentence summary',
              hintText: 'Example: Practiced linked lists for 1 hour.',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 52,
            child: FilledButton(
              onPressed: _saving ? null : _submit,
              child: _saving ? const CircularProgressIndicator() : const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}
