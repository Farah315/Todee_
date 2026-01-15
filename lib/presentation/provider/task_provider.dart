import 'package:flutter/material.dart';
import '../../domain/entity/task.dart';
import '../../domain/repository/task_repository.dart';

enum TaskFilter { all, active, completed }

class TaskProvider extends ChangeNotifier {
  final TaskRepository repository;

  List<Task> _tasks = [];
  bool _isLoading = false;
  String? _errorMessage;
  TaskFilter _filter = TaskFilter.all;

  TaskProvider({required this.repository});

  List<Task> get tasks {
    switch (_filter) {
      case TaskFilter.all:
        return _tasks;
      case TaskFilter.active:
        return _tasks.where((t) => !t.isCompleted).toList();
      case TaskFilter.completed:
        return _tasks.where((t) => t.isCompleted).toList();
    }
  }

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  TaskFilter get filter => _filter;

  int get completedCount => _tasks.where((t) => t.isCompleted).length;
  int get activeCount => _tasks.where((t) => !t.isCompleted).length;

  void setFilter(TaskFilter filter) {
    _filter = filter;
    notifyListeners();
  }

  Future<void> loadTasks() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await repository.getAllTasks();
    result.fold(
          (error) {
        _errorMessage = error.message;
        _isLoading = false;
        notifyListeners();
      },
          (tasks) {
        _tasks = tasks;
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<bool> addTask(Task task) async {
    final result = await repository.addTask(task);
    return result.fold(
          (error) {
        _errorMessage = error.message;
        notifyListeners();
        return false;
      },
          (id) {
        loadTasks();
        return true;
      },
    );
  }

  Future<bool> updateTask(Task task) async {
    final result = await repository.updateTask(task);
    return result.fold(
          (error) {
        _errorMessage = error.message;
        notifyListeners();
        return false;
      },
          (_) {
        loadTasks();
        return true;
      },
    );
  }

  Future<bool> deleteTask(String taskId) async {
    final result = await repository.deleteTask(taskId);
    return result.fold(
          (error) {
        _errorMessage = error.message;
        notifyListeners();
        return false;
      },
          (_) {
        loadTasks();
        return true;
      },
    );
  }

  Future<bool> toggleTaskCompletion(Task task) async {
    final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
    return await updateTask(updatedTask);
  }

  Future<bool> clearCompleted() async {
    final result = await repository.deleteAllCompleted();
    return result.fold(
          (error) {
        _errorMessage = error.message;
        notifyListeners();
        return false;
      },
          (_) {
        loadTasks();
        return true;
      },
    );
  }
}