final String tableTypes = 'eventTypes';

class EventTypeFields {
  static final String id = '_id';
  static final String name = 'name';
  static final String deletable = 'deletable';
}

class EventType {
  final int? id;
  final String name;
  final bool deletable;

  const EventType({this.id, required this.name, required this.deletable});

  static EventType fromJson(Map<String, Object?> json) {
    return EventType(
        id: json[EventTypeFields.id] as int?,
        name: json[EventTypeFields.name] as String,
        deletable: json[EventTypeFields.deletable] == 1);
  }
}
