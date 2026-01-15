import '../../../core/exception.dart';
import '../../../core/either.dart';
import '../entity/task.dart';

abstract class TaskRepository {
  Future<Either<AppException, int>> addTask(Task task);
  Future<Either<AppException, void>> updateTask(Task task);
  Future<Either<AppException, void>> deleteTask(String taskId);
  Future<Either<AppException, List<Task>>> getAllTasks();
  Future<Either<AppException, Task?>> getTaskById(String taskId);
  Future<Either<AppException, void>> deleteAllCompleted();
}