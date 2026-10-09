import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

class DoneTaskScreen extends StatefulWidget {
  const DoneTaskScreen({super.key});

  @override
  State<DoneTaskScreen> createState() => _DoneTaskScreenState();
}

class _DoneTaskScreenState extends State<DoneTaskScreen> {
  final doneBox = Hive.box('doneTasks');

  static const Color primaryColor = Color(0xFF6C63FF);
  static const Color backgroundColor = Color(0xFFF7F7FC);
  static const Color textColor = Color(0xFF25243A);
  static const Color successColor = Color(0xFF329B75);

  void restoreTask(int index) {
    final task = doneBox.getAt(index);

    setState(() {
      Hive.box('myTasks').add(task);
      doneBox.deleteAt(index);
    });

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Task moved back to your active tasks.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  Future<void> deleteTask(int index) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete completed task?'),
        content: const Text('This task will be permanently removed.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFD65D70),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      setState(() => doneBox.deleteAt(index));
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalTasks = doneBox.length;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          tooltip: 'Back',
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'YOUR ACHIEVEMENTS',
              style: TextStyle(
                fontSize: 10,
                letterSpacing: 1.5,
                color: successColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Completed Tasks',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryCard(totalTasks),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 0, 22, 16),
              child: Row(
                children: [
                  const Text(
                    'Your accomplishments',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '$totalTasks completed',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF85849A),
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
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                      itemCount: totalTasks,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final task = doneBox.getAt(index);
                        final title =
                            task['title']?.toString() ?? 'Untitled task';
                        final description = task['desc']?.toString() ?? '';

                        return _buildTaskCard(
                          title: title,
                          description: description,
                          onRestore: () => restoreTask(index),
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
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 26),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFFE5F5EC),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFD4EDDF)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'GREAT JOB!',
                  style: TextStyle(
                    fontSize: 11,
                    letterSpacing: 1.5,
                    color: successColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  totalTasks == 0
                      ? 'Your journey starts here'
                      : '$totalTasks ${totalTasks == 1 ? 'task' : 'tasks'} completed!',
                  style: const TextStyle(
                    fontSize: 20,
                    height: 1.3,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Every small achievement matters.',
                  style: TextStyle(fontSize: 12, color: Color(0xFF658273)),
                ),
              ],
            ),
          ),
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(19),
            ),
            child: const Icon(
              Icons.emoji_events_rounded,
              color: successColor,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 104,
              height: 104,
              decoration: const BoxDecoration(
                color: Color(0xFFE5F5EC),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.task_alt_rounded,
                size: 54,
                color: successColor,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No completed tasks yet',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Finish a task from your active list and it will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                color: Color(0xFF85849A),
              ),
            ),
            const SizedBox(height: 22),
            OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_rounded),
              label: const Text('Back to my tasks'),
              style: OutlinedButton.styleFrom(
                foregroundColor: primaryColor,
                side: const BorderSide(color: primaryColor),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
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
    required VoidCallback onRestore,
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
          IconButton(
            tooltip: 'Mark as incomplete',
            onPressed: onRestore,
            icon: const Icon(
              Icons.check_circle_rounded,
              color: successColor,
              size: 27,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF85849A),
                    decoration: TextDecoration.lineThrough,
                    decorationColor: successColor,
                    decorationThickness: 1.5,
                  ),
                ),
                if (description.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.5,
                      color: Color(0xFF9998A9),
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
