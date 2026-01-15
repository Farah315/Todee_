import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/AppLocalizations.dart';
import '../../domain/entity/task.dart';
import '../component/add_task_dialog.dart';
import '../component/task_item.dart';
import '../provider/locale_provider.dart';
import '../provider/task_provider.dart';
import '../provider/theme_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _fabController;

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
      value: 1.0,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskProvider>().loadTasks();
    });
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final language = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final taskProvider = context.watch<TaskProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final localeProvider = context.watch<LocaleProvider>();

    return Directionality(
      textDirection: localeProvider.locale.languageCode == 'ar'
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            language.translate('appTitle'),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.language),
              onPressed: localeProvider.toggleLocale,
              tooltip: localeProvider.locale.languageCode == 'en' ? 'العربية' : 'English',
            ),

            IconButton(
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, anim) => RotationTransition(
                  turns: anim,
                  child: FadeTransition(opacity: anim, child: child),
                ),
                child: Icon(
                  themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                  key: ValueKey(themeProvider.isDarkMode),
                ),
              ),
              onPressed: themeProvider.toggleTheme,
            ),
          ],
        ),

        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip(
                      context,
                      language.translate('all'),
                      TaskFilter.all,
                      taskProvider,
                      Icons.list,
                    ),
                    const SizedBox(width: 8),
                    _buildFilterChip(
                      context,
                      language.translate('active'),
                      TaskFilter.active,
                      taskProvider,
                      Icons.radio_button_unchecked,
                    ),
                    const SizedBox(width: 8),
                    _buildFilterChip(
                      context,
                      language.translate('completed'),
                      TaskFilter.completed,
                      taskProvider,
                      Icons.check_circle,
                    ),
                    if (taskProvider.completedCount > 0) ...[
                      const SizedBox(width: 16),
                      ActionChip(
                        avatar: Icon(
                          Icons.clear_all,
                          color: theme.colorScheme.error,
                          size: 18,
                        ),
                        label: Text(
                          language.translate('clearCompleted'),
                          style: TextStyle(color: theme.colorScheme.error),
                        ),
                        onPressed: () => _clearCompleted(context, taskProvider, language),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCounter(
                    context,
                    language.translate('active'),
                    taskProvider.activeCount,
                    theme.colorScheme.primary,
                  ),
                  _buildCounter(
                    context,
                    language.translate('completed'),
                    taskProvider.completedCount,
                    Colors.green,
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            Expanded(
              child: taskProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : taskProvider.tasks.isEmpty
                  ? _buildEmptyState(context, language)
                  : ListView.builder(
                padding: const EdgeInsets.only(bottom: 80),
                itemCount: taskProvider.tasks.length,
                itemBuilder: (context, index) {
                  final task = taskProvider.tasks[index];
                  return TaskItem(
                    key: ValueKey(task.id),
                    task: task,
                    onToggle: () => taskProvider.toggleTaskCompletion(task),
                    onDelete: () => taskProvider.deleteTask(task.id),
                    onEdit: () => _editTask(context, task),
                  );
                },
              ),
            ),
          ],
        ),

        floatingActionButton: ScaleTransition(
          scale: CurvedAnimation(
            parent: _fabController,
            curve: Curves.elasticOut,
          ),
          child: FloatingActionButton.extended(
            onPressed: () => _addTask(context),
            icon: const Icon(Icons.add),
            label: Text(language.translate('addTask')),
            elevation: 4,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(
      BuildContext context,
      String label,
      TaskFilter filter,
      TaskProvider provider,
      IconData icon,
      ) {
    final isSelected = provider.filter == filter;
    final theme = Theme.of(context);

    return FilterChip(
      selected: isSelected,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
      onSelected: (_) => provider.setFilter(filter),
      selectedColor: theme.colorScheme.primaryContainer,
      checkmarkColor: theme.colorScheme.primary,
    );
  }

  Widget _buildCounter(BuildContext context, String label, int count, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '$count',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context, AppLocalizations language) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.task_alt,
            size: 100,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
          ),
          const SizedBox(height: 24),
          Text(
            language.translate('noTasks'),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addTask(BuildContext context) async {

    await _fabController.reverse();
    await _fabController.forward();

    final task = await showDialog<Task>(
      context: context,
      builder: (context) => const AddTaskDialog(),
    );

    if (task != null && mounted) {
      final success = await context.read<TaskProvider>().addTask(task);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✓ ${AppLocalizations.of(context).translate('addTask')}'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _editTask(BuildContext context, Task task) async {
    final updatedTask = await showDialog<Task>(
      context: context,
      builder: (context) => AddTaskDialog(task: task),
    );

    if (updatedTask != null && mounted) {
      final success = await context.read<TaskProvider>().updateTask(updatedTask);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✓ ${AppLocalizations.of(context).translate('editTask')}'),
            backgroundColor: Colors.blue,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _clearCompleted(
      BuildContext context,
      TaskProvider provider,
      AppLocalizations language,
      ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(language.translate('clearCompleted')),
        content: Text('${language.translate('deleteConfirm')} (${provider.completedCount})'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(language.translate('no')),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(language.translate('yes')),
          ),
        ],
      ),
    );

    if (result == true && mounted) {
      await provider.clearCompleted();
    }
  }
}