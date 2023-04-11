final String tableBreak = 'breakTypes';

class BreakTypeFields {
  static final String id = '_id';
  static final String name = 'name';
}

class BreakType {
  final int? id;
  final String name;

  const BreakType({this.id, required this.name});

  static BreakType fromJson(Map<String, Object?> json) {
    return BreakType(
        id: json[BreakTypeFields.id] as int?,
        name: json[BreakTypeFields.name] as String);
  }
}
