class ExpenseDto {
  int id;
  DateTime date;
  int odometer;
  double totalCost;
  String note;

  ExpenseDto(
      {required this.id,
      required this.date,
      required this.odometer,
      required this.totalCost,
      required this.note});

  factory ExpenseDto.fromJson(Map<String, dynamic> json) {
    return ExpenseDto(
        id: json['id'] as int,
        date: DateTime.parse(json['date']),
        odometer: json['odometer'] as int,
        totalCost: json['totalCost'] as double,
        note: json['note'] as String);
  }
}
