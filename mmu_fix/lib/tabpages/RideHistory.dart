class RideHistory {
  final String destination;
  final DateTime dateTime;
  final double cost;

  RideHistory({required this.destination, required this.dateTime, required this.cost});

  factory RideHistory.fromMap(Map<String, dynamic> data) {
    return RideHistory(
      destination: data['destination'],
      dateTime: DateTime.fromMillisecondsSinceEpoch(data['dateTime']),
      cost: data['cost'].toDouble(),
    );
  }
}
