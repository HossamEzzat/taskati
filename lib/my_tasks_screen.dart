import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:lottie/lottie.dart';
import 'package:taskati/add_task_screen.dart';

import 'done_task_screen.dart';

class MyTasksScreen extends StatefulWidget {
  const MyTasksScreen({super.key});

  @override
  State<MyTasksScreen> createState() => _MyTasksScreenState();
}

class _MyTasksScreenState extends State<MyTasksScreen> {
  final taskBox = Hive.box('myTasks');

  static const Color primaryColor = Color(0xFF6C63FF);
  static const Color backgroundColor = Color(0xFFF7F7FC);
  static const Color textColor = Color(0xFF25243A);

  Future<void> navigateTo(Widget screen) async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => screen));

    if (mounted) setState(() {});
  }

  Future<void> deleteTask(int index) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete task?'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFD94F61),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      setState(() => taskBox.deleteAt(index));
    }
  }

  void completeTask(int index) {
    final task = taskBox.getAt(index);

    setState(() {
      Hive.box('doneTasks').add(task);
      taskBox.deleteAt(index);
    });

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Task completed successfully!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final totalTasks = taskBox.length;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'WELCOME BACK',
              style: TextStyle(
                fontSize: 11,
                letterSpacing: 1.8,
                color: primaryColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'My Tasks',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton.filledTonal(
              tooltip: 'Completed tasks',
              onPressed: () => navigateTo(DoneTaskScreen()),
              icon: const Icon(Icons.task_alt_rounded),
              style: IconButton.styleFrom(
                foregroundColor: primaryColor,
                backgroundColor: const Color(0xFFECEBFF),
                minimumSize: const Size(48, 48),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryCard(totalTasks),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 4, 22, 14),
              child: Row(
                children: [
                  const Text(
                    'Your tasks',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '$totalTasks ${totalTasks == 1 ? 'task' : 'tasks'}',
                    style: const TextStyle(
                      color: Color(0xFF85849A),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: totalTasks == 0
                  ? _buildEmptyState()
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                      itemCount: totalTasks,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final task = taskBox.getAt(index);
                        final title =
                            task['title']?.toString() ?? 'Untitled task';
                        final description = task['desc']?.toString() ?? '';

                        return _buildTaskCard(
                          title: title,
                          description: description,
                          onComplete: () => completeTask(index),
                          onDelete: () => deleteTask(index),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(int totalTasks) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 22, 20, 28),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.18),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'STAY FOCUSED',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  totalTasks == 0
                      ? 'A fresh start!'
                      : '$totalTasks tasks to go',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'One step at a time. You got this!',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.16),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.rocket_launch_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(28, 12, 28, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 180,
              child: Lottie.asset('assets/empty.json', fit: BoxFit.contain),
            ),
            const SizedBox(height: 16),
            const Text(
              'Nothing on your list yet',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Create your first task and make today productive.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF85849A),
                fontSize: 14,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 22),
            FilledButton.icon(
              onPressed: () => navigateTo(AddTaskScreen()),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Create your first task'),
              style: FilledButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCard({
    required String title,
    required String description,
    required VoidCallback onComplete,
    required VoidCallback onDelete,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFECEBF4)),
      ),
      child: Row(
        children: [
          Checkbox(
            value: false,
            onChanged: (value) {
              if (value == true) onComplete();
            },
            activeColor: primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: textColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (description.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF85849A),
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            tooltip: 'Delete task',
            onPressed: onDelete,
            icon: const Icon(
              Icons.delete_outline_rounded,
              color: Color(0xFFD65D70),
            ),
          ),
        ],
      ),
    );
  }
}
