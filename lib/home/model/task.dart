class Task {
  final String title; // Task title
  final String description; // Task description

  Task({
    required this.title, // Constructor requires title
    required this.description, // Constructor requires description
  });

  // Convert a Task instance to a Map (for JSON serialization)
  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
      };

  // Create a Task instance from a Map (for JSON deserialization)
  factory Task.fromJson(Map<String, dynamic> json) => Task(
        title: json['title'],
        description: json['description'],
      );
}
