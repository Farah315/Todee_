class Task {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
  });

  bool get isNew => id.isEmpty;
  bool hasDescription() => description.trim().isNotEmpty;
  bool isValid() => title.trim().isNotEmpty;
  int get titleLength => title.length;
  int get descriptionLength => description.length;

  Task copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  String toString() {
    return 'Task(id: $id, title: $title, description: $description, isCompleted: $isCompleted)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Task && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

Task toggleTaskCompletion(Task task) {
  return task.copyWith(isCompleted: !task.isCompleted);
}