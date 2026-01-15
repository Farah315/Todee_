import '../../domain/entity/task.dart';

class TaskModel extends Task {
  TaskModel({
    required super.id,
    required super.title,
    required super.description,
    required super.isCompleted,
  });

  factory TaskModel.fromEntity(Task task) {
    return TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      isCompleted: task.isCompleted,
    );
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'].toString(),
      title: map['title'] as String,
      description: map['description'] as String,
      isCompleted: (map['isComplete'] as int) == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'isComplete': isCompleted ? 1 : 0,
    };
  }

  Map<String, dynamic> toMapWithId() {
    return {
      'id': int.parse(id),
      'title': title,
      'description': description,
      'isComplete': isCompleted ? 1 : 0,
    };
  }

  Task toEntity() {
    return Task(
      id: id,
      title: title,
      description: description,
      isCompleted: isCompleted,
    );
  }
}