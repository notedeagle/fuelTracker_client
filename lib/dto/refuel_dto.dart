class RefuelDto {
  int id;
  DateTime date;
  String fuel;
  bool fullTank;
  double litres;
  int odometer;
  double price;
  double totalCost;

  RefuelDto(
      {required this.id,
      required this.date,
      required this.fuel,
      required this.fullTank,
      required this.litres,
      required this.odometer,
      required this.totalCost,
      required this.price});

  factory RefuelDto.fromJson(Map<String, dynamic> json) {
    return RefuelDto(
        id: json['id'] as int,
        date: DateTime.parse(json['date']),
        fuel: json['fuel'] as String,
        fullTank: json['fullTank'] as bool,
        litres: json['litres'] as double,
        odometer: json['odometer'] as int,
        totalCost: json['totalCost'] as double,
        price: json['price'] as double);
  }
}
