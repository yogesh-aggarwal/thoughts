class Thought {
  String id;
  String title;
  int dateCreated;

  Thought({
    required this.id,
    required this.title,
    required this.dateCreated,
  });

  factory Thought.fromMap(Map<String, dynamic> json) {
    return Thought(
      id: json['id'],
      title: json['title'],
      dateCreated: json['dateCreated'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'dateCreated': dateCreated,
    };
  }

  @override
  String toString() {
    return 'Thought{id: $id, title: $title, dateCreated: $dateCreated}';
  }
}
