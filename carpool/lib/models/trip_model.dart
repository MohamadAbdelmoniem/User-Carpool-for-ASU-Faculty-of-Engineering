// models/trip_model.dart
class Trip {
  final String id;
  final String from;
  final String to;
  final String time;
  final String driverName;
  final String date;
  final int price;
  final int availableSeats;
  final int gate;

  Trip({
    required this.id,
    required this.from,
    required this.to,
    required this.time,
    required this.driverName,
    required this.price,
    required this.date,
    required this.availableSeats,
    required this.gate,
  });

  factory Trip.fromMap(String id, Map<String, dynamic> map) {
    return Trip(
      id: id,
      from: map['from'],
      to: map['to'],
      time: map['time'],
      driverName: map['driverName'],
      price: map['price'],
      date: map['date'] ?? '',
      availableSeats: map['availableSeats'] ?? 0,
      gate: map['gate'] ?? 0,
    );
  }
}
