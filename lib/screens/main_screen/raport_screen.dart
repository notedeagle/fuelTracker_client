// ignore_for_file: unnecessary_const

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tracker_client/bloc/auth_bloc/auth.dart';
import 'package:flutter_tracker_client/dto/refuel_dto.dart';
import 'package:flutter_tracker_client/repositories/repositories.dart';
import 'package:flutter_tracker_client/screens/vahicle_screen/vehicle_screen.dart';
import 'package:flutter_tracker_client/style/theme.dart' as style;
import 'package:intl/intl.dart';

class RaportScreen extends StatefulWidget {
  final String carName;

  const RaportScreen({Key? key, required this.carName}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => _RaportScreenState(carName: carName);
}

class _RaportScreenState extends State<RaportScreen> {
  var refuelRepository = RefuelRepository();
  String carName;

  _RaportScreenState({required this.carName});

  sumCost(List<RefuelDto> list) {
    double sum = 0;

    for (var element in list) {
      sum += element.totalCost;
    }

    return sum;
  }

  perDay(List<RefuelDto> list) {
    final days = list.last.date.difference(list.first.date);

    return sumCost(list) / days.inDays;
  }

  perKm(List<RefuelDto> list) {
    final km = list.last.odometer - list.first.odometer;
    return sumCost(list) / km;
  }

  allLitres(List<RefuelDto> list) {
    double sum = 0;

    for (var element in list) {
      sum += element.litres;
    }

    return sum;
  }

  avgLitres(List<RefuelDto> list) {
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        endDrawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: style.Colors.mainColor),
                child: Text(""),
              ),
              ListTile(
                  leading: const Icon(EvaIcons.fileAdd),
                  title: const Text("Vehicles"),
                  onTap: () {
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const VehicleScreen()))
                        .then((_) => setState(() {}));
                  }),
              ListTile(
                leading: const Icon(EvaIcons.logOutOutline),
                title: const Text("Log out"),
                onTap: () {
                  BlocProvider.of<AuthenticationBloc>(context).add(
                    LoggedOut(),
                  );
                },
              )
            ],
          ),
        ),
        appBar: AppBar(
            backgroundColor: style.Colors.mainColor,
            leading: InkWell(
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            title: const Center(child: Text("Raports"))),
        body: FutureBuilder<List<RefuelDto>>(
          future: refuelRepository.getRefuelByCarName(carName),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<RefuelDto>? data = snapshot.data;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
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
                      height: 60,
                      width: 390,
                      padding:
                          const EdgeInsets.only(top: 15, left: 15, right: 15),
                      child: Center(
                          child: Text(DateFormat('dd-MM-yyyy')
                                  .format(data!.first.date) +
                              " - " +
                              DateFormat('dd-MM-yyyy').format(data.last.date))),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
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
                      height: 140,
                      width: 390,
                      padding:
                          const EdgeInsets.only(top: 15, left: 15, right: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Cost",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14.0),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                children: [
                                  const Text(
                                    "Sum",
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14.0),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    sumCost(data).toStringAsFixed(2) + "zl",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                width: 65,
                              ),
                              Column(children: [
                                const Text(
                                  "Per day",
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14.0),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  perDay(data).toStringAsFixed(2) + "zl",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0),
                                ),
                              ]),
                              const SizedBox(
                                width: 65,
                              ),
                              Column(children: [
                                const Text(
                                  "Per km",
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14.0),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  perKm(data).toStringAsFixed(2) + "zl",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0),
                                ),
                              ])
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
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
                      height: 140,
                      width: 390,
                      padding:
                          const EdgeInsets.only(top: 15, left: 15, right: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Fuel",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14.0),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                width: 80,
                              ),
                              Column(
                                children: [
                                  const Text(
                                    "All",
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14.0),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    allLitres(data).toStringAsFixed(2) + "l",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                width: 65,
                              ),
                              Column(children: [
                                const Text(
                                  "Average",
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14.0),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  avgLitres(data).toStringAsFixed(2) + "zl",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0),
                                ),
                              ]),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
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
                      height: 140,
                      width: 390,
                      padding:
                          const EdgeInsets.only(top: 15, left: 15, right: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Cost",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14.0),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                children: [
                                  const Text(
                                    "Last",
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14.0),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    sumCost(data).toStringAsFixed(2) + "zl",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                width: 50,
                              ),
                              Column(children: [
                                const Text(
                                  "Minimum",
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14.0),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  perDay(data).toStringAsFixed(2) + "zl",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0),
                                ),
                              ]),
                              const SizedBox(
                                width: 50,
                              ),
                              Column(children: [
                                const Text(
                                  "Maximum",
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14.0),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  perKm(data).toStringAsFixed(2) + "zl",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0),
                                ),
                              ])
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return const CircularProgressIndicator();
          },
        ));
  }
}
