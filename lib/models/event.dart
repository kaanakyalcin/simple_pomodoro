final String tableEvents = 'events';

class EventFields {
  static final String id = '_id';
  static final String typeId = 'typeId';
  static final String time = 'time';
  static final String breakId = 'breakId';
}

class Event {
  final int? id;
  final int typeId;
  final int time;
  final int breakId;

  const Event(
      {this.id,
      required this.typeId,
      required this.time,
      required this.breakId});

  static Event fromJson(Map<String, Object?> json) {
    return Event(
        id: json[EventFields.id] as int?,
        typeId: json[EventFields.typeId] as int,
        time: json[EventFields.time] as int,
        breakId: json[EventFields.breakId] as int);
  }
}
