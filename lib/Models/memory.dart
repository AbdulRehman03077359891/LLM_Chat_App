class Memory {
  final int id;
  final String userId;
  final String key;
  final String value;
  final DateTime timestamp;

  Memory({
    required this.id,
    required this.userId,
    required this.key,
    required this.value,
    required this.timestamp,
  });

  // Convert memory to a map (for saving to database)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'key': key,
      'value': value,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  // Convert map to memory object
  factory Memory.fromMap(Map<String, dynamic> map) {
    return Memory(
      id: map['id'],
      userId: map['userId'],
      key: map['key'],
      value: map['value'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}
