class VehicleDto {
  String brand;
  int mileage;
  String model;
  String name;
  String plateNumber;
  int registartionYear;
  String vehicleType;
  int yearOfProduction;

  VehicleDto(
      {required this.brand,
      required this.mileage,
      required this.model,
      required this.name,
      required this.plateNumber,
      required this.registartionYear,
      required this.vehicleType,
      required this.yearOfProduction});

  factory VehicleDto.fromJson(Map<String, dynamic> json) {
    return VehicleDto(
        brand: json['brand'] as String,
        mileage: json['mileage'] as int,
        model: json['model'] as String,
        name: json['name'] as String,
        plateNumber: json['plateNumber'] as String,
        registartionYear: json['registrationYear'] as int,
        vehicleType: json['vehicleType'] as String,
        yearOfProduction: json['yearOfProduction'] as int);
  }
}
