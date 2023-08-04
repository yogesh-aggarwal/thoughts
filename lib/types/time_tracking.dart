class TimeTrackingSession {
  int start;
  int end;

  TimeTrackingSession({
    required this.start,
    required this.end,
  });

  int get duration => end - start;

  factory TimeTrackingSession.fromJson(Map<String, dynamic> json) {
    return TimeTrackingSession(
      start: json["start"],
      end: json["end"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "start": start,
      "end": end,
    };
  }
}

class TimeTrack {
  String id;
  String name;
  List<TimeTrackingSession> sessions;
  String createdBy;
  int dateCreated;
  int dayCreated;

  TimeTrack({
    required this.id,
    required this.name,
    required this.sessions,
    required this.createdBy,
    required this.dateCreated,
    required this.dayCreated,
  });

  int get duration {
    int total = 0;
    for (var session in sessions) {
      total += session.duration;
    }
    return total;
  }

  factory TimeTrack.fromMap(Map<String, dynamic> json) {
    return TimeTrack(
      id: json["id"],
      name: json["name"],
      sessions: (json["sessions"] as List<dynamic>)
          .map((session) => TimeTrackingSession.fromJson(session))
          .toList(),
      createdBy: json["createdBy"],
      dateCreated: json["dateCreated"],
      dayCreated: json["dayCreated"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "sessions": sessions.map((session) => session.toJson()).toList(),
      "createdBy": createdBy,
      "dateCreated": dateCreated,
      "dayCreated": dayCreated,
    };
  }
}
