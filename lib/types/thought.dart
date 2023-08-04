class Thought {
  String id;
  String content;
  int dayCreated;
  int dateCreated;
  String createdBy;

  Thought({
    required this.id,
    required this.content,
    required this.dayCreated,
    required this.dateCreated,
    required this.createdBy,
  });

  factory Thought.fromMap(Map<String, dynamic> json) {
    return Thought(
      id: json['id'],
      content: json['content'],
      dayCreated: json['dayCreated'],
      dateCreated: json['dateCreated'],
      createdBy: json['createdBy'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'dayCreated': dayCreated,
      'dateCreated': dateCreated,
      'createdBy': createdBy,
    };
  }

  @override
  String toString() {
    return 'Thought{id: $id, content: $content, dateCreated: $dateCreated, dayCreated: $dayCreated, createdBy: $createdBy}';
  }
}
