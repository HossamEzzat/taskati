import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  final GlobalKey<FormState> key = GlobalKey<FormState>();

  static const Color primaryColor = Color(0xFF6C63FF);
  static const Color backgroundColor = Color(0xFFF7F7FC);
  static const Color textColor = Color(0xFF25243A);

  bool isSaving = false;

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }

  Future<void> saveTask() async {
    if (isSaving) return;

    FocusScope.of(context).unfocus();

    if (!(key.currentState?.validate() ?? false)) return;

    setState(() => isSaving = true);

    try {
      final data = {
        'title': titleController.text.trim(),
        'desc': descController.text.trim(),
        'isCheck': false,
      };

      await Hive.box('myTasks').add(data);

      if (!mounted) return;
      Navigator.pop(context);
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to save task. Please try again.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => isSaving = false);
      }
    }
  }

  String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a task title';
    }

    if (value.trim().length < 2) {
      return 'Title must contain at least 2 characters';
    }

    return null;
  }

  String? validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a task description';
    }

    return null;
  }

  InputDecoration buildInputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF9998A9), fontSize: 14),
      prefixIcon: Icon(icon, color: primaryColor, size: 21),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFE8E7F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFE8E7F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: primaryColor, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFD65D70)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFD65D70), width: 1.5),
      ),
    );
  }

  Widget buildFieldLabel(String label, {bool required = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
          if (required)
            const Text(
              ' *',
              style: TextStyle(
                color: Color(0xFFD65D70),
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Create Task',
          style: TextStyle(
            color: textColor,
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Form(
          key: key,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(22, 12, 22, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECEBFF),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: const Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Make it happen!',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Write down your next goal and take the first step.',
                              style: TextStyle(
                                color: Color(0xFF77748F),
                                fontSize: 13,
                                height: 1.6,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 12),
                      Icon(
                        Icons.edit_note_rounded,
                        color: primaryColor,
                        size: 48,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                buildFieldLabel('Task title'),
                TextFormField(
                  controller: titleController,
                  validator: validateTitle,
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.next,
                  maxLength: 80,
                  decoration: buildInputDecoration(
                    hint: 'What do you need to do?',
                    icon: Icons.title_rounded,
                  ).copyWith(counterText: ''),
                ),
                const SizedBox(height: 24),
                buildFieldLabel('Description'),
                TextFormField(
                  controller: descController,
                  validator: validateDescription,
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.newline,
                  keyboardType: TextInputType.multiline,
                  minLines: 4,
                  maxLines: 6,
                  maxLength: 500,
                  decoration: buildInputDecoration(
                    hint: 'Add details about your task...',
                    icon: Icons.notes_rounded,
                  ).copyWith(alignLabelWithHint: true, counterText: ''),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: FilledButton.icon(
                    onPressed: isSaving ? null : saveTask,
                    style: FilledButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: primaryColor.withOpacity(0.6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    icon: isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.add_task_rounded),
                    label: Text(
                      isSaving ? 'Saving task...' : 'Create Task',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Center(
                  child: Text(
                    'Every great achievement starts with a small step.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Color(0xFF9998A9)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
