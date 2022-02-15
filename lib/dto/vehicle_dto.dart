class VehicleDto {
  String brand;
  String model;
  String name;
  String plateNumber;
  String vehicleType;
  int yearOfProduction;
  double capacity;

  VehicleDto(
      {required this.brand,
      required this.model,
      required this.name,
      required this.plateNumber,
      required this.vehicleType,
      required this.yearOfProduction,
      required this.capacity});

  factory VehicleDto.fromJson(Map<String, dynamic> json) {
    return VehicleDto(
        brand: json['brand'] as String,
        model: json['model'] as String,
        name: json['name'] as String,
        plateNumber: json['plateNumber'] as String,
        vehicleType: json['vehicleType'] as String,
        yearOfProduction: json['yearOfProduction'] as int,
        capacity: json['capacity'] as double);
  }
}
