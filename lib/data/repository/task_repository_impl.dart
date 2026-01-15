import '../../core/either.dart';
import '../../core/exception.dart';
import '../../domain/entity/task.dart';
import '../../domain/repository/task_repository.dart';
import '../datasource/local.dart';
import '../models/task.dart';


class TaskRepositoryImpl implements TaskRepository {
  final LocalDatabase database;

  TaskRepositoryImpl({required this.database});

  @override
  Future<Either<AppException, int>> addTask(Task task) async {
    try {
      if (!task.isValid()) {
        return Left(ValidationException('Task title cannot be empty'));
      }

      final taskModel = TaskModel.fromEntity(task);
      final id = await database.insertTask(taskModel.toMap());
      return Right(id);
    } catch (e) {
      return Left(DatabaseException('Failed to add task: ${e.toString()}'));
    }
  }

  @override
  Future<Either<AppException, void>> updateTask(Task task) async {
    try {
      if (!task.isValid()) {
        return Left(ValidationException('Task title cannot be empty'));
      }

      final taskModel = TaskModel.fromEntity(task);
      await database.updateTask(int.parse(task.id), taskModel.toMap());
      return const Right(null);
    } catch (e) {
      return Left(DatabaseException('Failed to update task: ${e.toString()}'));
    }
  }

  @override
  Future<Either<AppException, void>> deleteTask(String taskId) async {
    try {
      await database.deleteTask(int.parse(taskId));
      return const Right(null);
    } catch (e) {
      return Left(DatabaseException('Failed to delete task: ${e.toString()}'));
    }
  }

  @override
  Future<Either<AppException, List<Task>>> getAllTasks() async {
    try {
      final tasksMap = await database.getAllTasks();
      final tasks = tasksMap.map((map) => TaskModel.fromMap(map).toEntity()).toList();
      return Right(tasks);
    } catch (e) {
      return Left(DatabaseException('Failed to get tasks: ${e.toString()}'));
    }
  }

  @override
  Future<Either<AppException, Task?>> getTaskById(String taskId) async {
    try {
      final tasks = await database.getAllTasks();
      final taskMap = tasks.firstWhere(
            (map) => map['id'].toString() == taskId,
        orElse: () => {},
      );

      if (taskMap.isEmpty) {
        return const Right(null);
      }

      return Right(TaskModel.fromMap(taskMap).toEntity());
    } catch (e) {
      return Left(DatabaseException('Failed to get task: ${e.toString()}'));
    }
  }

  @override
  Future<Either<AppException, void>> deleteAllCompleted() async {
    try {
      await database.deleteAllCompleted();
      return const Right(null);
    } catch (e) {
      return Left(DatabaseException('Failed to delete completed tasks: ${e.toString()}'));
    }
  }
}