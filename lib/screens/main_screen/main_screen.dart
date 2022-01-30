import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tracker_client/bloc/auth_bloc/auth.dart';
import 'package:flutter_tracker_client/dto/refuel_dto.dart';
import 'package:flutter_tracker_client/dto/vehicle_dto.dart';
import 'package:flutter_tracker_client/repositories/repositories.dart';
import 'package:intl/intl.dart';
import 'package:flutter_tracker_client/style/theme.dart' as style;

class MainScreen extends StatefulWidget {
  static RefuelRepository refuelRepository = RefuelRepository();

  const MainScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var vehicleRepository = VehicleRepository();
  late String vehicleValue = "";

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<VehicleDto>>(
      future: vehicleRepository.getCustomerVehicles(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<VehicleDto>? cars = snapshot.data;
          if (vehicleValue == "") {
            vehicleValue = cars![0].name;
          }
          return Scaffold(
              appBar: AppBar(
                backgroundColor: style.Colors.mainColor,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    DropdownButton<String>(
                        value: vehicleValue,
                        selectedItemBuilder: (_) {
                          return cars!
                              .map((e) => Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      e.name,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ))
                              .toList();
                        },
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                        onChanged: (String? newValue) {
                          setState(() {
                            vehicleValue = newValue!;
                          });
                        },
                        items: cars!
                            .map<DropdownMenuItem<String>>((VehicleDto value) {
                          return DropdownMenuItem<String>(
                            value: value.name,
                            child: Text(value.name,
                                style: const TextStyle(color: Colors.black)),
                          );
                        }).toList()),
                    const SizedBox(width: 40),
                    const Text("Fuel tracker"),
                  ],
                ),
                actions: [
                  IconButton(
                      icon: const Icon(EvaIcons.logOutOutline),
                      onPressed: () {
                        BlocProvider.of<AuthenticationBloc>(context).add(
                          LoggedOut(),
                        );
                      })
                ],
              ),
              body: Center(
                  child: FutureBuilder<List<RefuelDto>>(
                future: RefuelRepository().getRefuelByCarName(vehicleValue),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<RefuelDto>? data = snapshot.data;
                    return Container(
                        padding: const EdgeInsets.only(top: 4),
                        child: ListView.separated(
                            itemCount: data!.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 4),
                            itemBuilder: (BuildContext conext, int index) {
                              return Container(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10)),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: const Offset(0, 3))
                                      ]),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 100,
                                        width: 200,
                                        padding: const EdgeInsets.only(
                                            top: 15, left: 15, right: 15),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              DateFormat('dd-MM-yyyy\nHH:mm:ss')
                                                  .format(data[index].date),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14.0),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: 100,
                                        width: 190,
                                        padding: const EdgeInsets.only(
                                            top: 15, left: 60),
                                        child: Column(
                                          children: [
                                            Text(
                                              data[index].odometer.toString() +
                                                  " km",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14.0),
                                            ),
                                            Text(
                                              data[index].fuel +
                                                  "  (" +
                                                  data[index]
                                                      .litres
                                                      .toString() +
                                                  ")l",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14.0),
                                            ),
                                            Text(
                                              data[index].price.toString() +
                                                  "zl/l",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14.0),
                                            ),
                                            Text(
                                              data[index].totalCost.toString() +
                                                  "zl",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14.0),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ));
                            }));
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }

                  return const CircularProgressIndicator();
                },
              )));
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
