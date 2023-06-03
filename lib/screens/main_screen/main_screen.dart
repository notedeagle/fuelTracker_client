import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tracker_client/bloc/auth_bloc/auth.dart';
import 'package:flutter_tracker_client/dto/mapper.dart';
import 'package:flutter_tracker_client/dto/vehicle_dto.dart';
import 'package:flutter_tracker_client/dto/view_dto.dart';
import 'package:flutter_tracker_client/repositories/repositories.dart';
import 'package:flutter_tracker_client/screens/expense_screen/add_expense_screen.dart';
import 'package:flutter_tracker_client/screens/main_screen/expandable_fab.dart';
import 'package:flutter_tracker_client/screens/main_screen/raport_screen.dart';
import 'package:flutter_tracker_client/screens/refuel_screen/add_refuel_screen.dart';
import 'package:flutter_tracker_client/screens/vahicle_screen/vehicle_screen.dart';
import 'package:intl/intl.dart';
import 'package:flutter_tracker_client/style/theme.dart' as style;

import '../refuel_screen/refuel_map_form.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var vehicleRepository = VehicleRepository();
  var refuelRepository = RefuelRepository();
  var expanseRepository = ExpenseRepository();
  String vehicleValue = "";
  String vehicleType = "";
  int lastOdometer = 0;
  double latidude = 0;
  double longtitude = 0;

  avg(ViewDto data, ViewDto data2) {
    final km = data.odometer - data2.odometer;
    return data.litres / km * 100;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<VehicleDto>>(
      future: vehicleRepository.getCustomerVehicles(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<VehicleDto>? cars = snapshot.data;
          if (cars!.isNotEmpty) {
            if (vehicleValue == "") {
              vehicleValue = cars[0].name;
            }
            return Scaffold(
                endDrawer: Drawer(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      const DrawerHeader(
                        decoration:
                            BoxDecoration(color: style.Colors.mainColor),
                        child: Text(""),
                      ),
                      ListTile(
                          leading: const Icon(EvaIcons.fileAdd),
                          title: const Text("Vehicles"),
                          onTap: () {
                            Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const VehicleScreen()))
                                .then((_) => setState(() {}));
                          }),
                      ListTile(
                        leading: const Icon(Icons.input),
                        title: const Text("Reports"),
                        onTap: () => {
                          Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RaportScreen(
                                          carName: vehicleValue,
                                          vehicleType: vehicleType)))
                              .then((_) => setState(() {}))
                        }, //add route to raports
                      ),
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
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        DropdownButton<String>(
                            value: vehicleValue,
                            selectedItemBuilder: (_) {
                              vehicleType = cars
                                  .where(
                                      (element) => element.name == vehicleValue)
                                  .first
                                  .vehicleType;
                              return cars
                                  .map((e) => Container(
                                        width: 50,
                                        alignment: Alignment.center,
                                        child: Text(
                                          e.name,
                                          style: const TextStyle(
                                              color: Colors.white),
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
                            items: cars.map<DropdownMenuItem<String>>(
                                (VehicleDto value) {
                              return DropdownMenuItem<String>(
                                value: value.name,
                                child: Text(value.name,
                                    style:
                                        const TextStyle(color: Colors.black)),
                              );
                            }).toList()),
                        const SizedBox(width: 30),
                        const Center(child: Text("Fuel tracker"))
                      ],
                    )),
                body: Center(
                    child: FutureBuilder<List<ViewDto>>(
                  future: Mapper().getViewListByVehicleName(vehicleValue),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<ViewDto>? data = snapshot.data;
                      data!.sort((a, b) => b.date.compareTo(a.date));
                      if (data.length > 1) {
                        lastOdometer = data[data.length - 1].odometer;
                      }
                      if (vehicleType == "PETROL") {
                        return Container(
                            padding: const EdgeInsets.only(top: 4),
                            child: ListView.separated(
                                itemCount: data.length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 4),
                                itemBuilder: (BuildContext conext, int index) {
                                  return InkWell(
                                      onTap: () => {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        RefuelMapScreen(
                                                          latitude: data[index]
                                                              .latitude,
                                                          longitude: data[index]
                                                              .longitude,
                                                        ))).then(
                                                (_) => setState(() {}))
                                          },
                                      child: Container(
                                          padding: const EdgeInsets.only(
                                              top: 10, bottom: 10),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(10),
                                                      topRight:
                                                          Radius.circular(10),
                                                      bottomLeft:
                                                          Radius.circular(10),
                                                      bottomRight:
                                                          Radius.circular(10)),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.5),
                                                    spreadRadius: 5,
                                                    blurRadius: 7,
                                                    offset: const Offset(0, 3))
                                              ]),
                                          child: Row(
                                            children: [
                                              Container(
                                                height: 115,
                                                width: 150,
                                                padding: const EdgeInsets.only(
                                                    top: 15,
                                                    left: 15,
                                                    right: 15),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      DateFormat(
                                                              'dd-MM-yyyy\nHH:mm:ss')
                                                          .format(
                                                              data[index].date),
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14.0),
                                                    ),
                                                    Text(
                                                      vehicleValue,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14.0),
                                                    ),
                                                    IconButton(
                                                      icon: const Icon(
                                                          EvaIcons.trash),
                                                      onPressed: () {
                                                        if (data[index].type ==
                                                            "REFUEL") {
                                                          refuelRepository
                                                              .removeRefuel(
                                                                  data[index]
                                                                      .id);
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(const SnackBar(
                                                                  content: Text(
                                                                      "Refuel deleted."),
                                                                  backgroundColor:
                                                                      Colors
                                                                          .green));
                                                          setState(() {});
                                                        } else if (data[index]
                                                                .type ==
                                                            "EXPENSE") {
                                                          expanseRepository
                                                              .removeExpense(
                                                                  data[index]
                                                                      .id);
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(const SnackBar(
                                                                  content: Text(
                                                                      "Expense deleted."),
                                                                  backgroundColor:
                                                                      Colors
                                                                          .green));
                                                          setState(() {});
                                                        }
                                                      },
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                height: 100,
                                                width: 240,
                                                padding: const EdgeInsets.only(
                                                    top: 15, left: 60),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      data[index]
                                                              .odometer
                                                              .toString() +
                                                          " km",
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14.0),
                                                    ),
                                                    if (data[index].type ==
                                                        "REFUEL") ...[
                                                      Text(
                                                        data[index].fuel + "l)",
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14.0),
                                                      ),
                                                      Text(
                                                        data[index].price +
                                                            "zl/l",
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14.0),
                                                      )
                                                    ],
                                                    Text(
                                                      data[index].totalCost,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14.0),
                                                    ),
                                                    if (data
                                                                .where((element) =>
                                                                    element
                                                                        .type ==
                                                                    "REFUEL")
                                                                .toList()
                                                                .length >
                                                            1 &&
                                                        data
                                                                .lastWhere(
                                                                    (element) =>
                                                                        element
                                                                            .type ==
                                                                        "REFUEL")
                                                                .id !=
                                                            data[index].id &&
                                                        data[index].type ==
                                                            "REFUEL") ...[
                                                      Text(
                                                        avg(
                                                                data[index],
                                                                data
                                                                    .sublist(
                                                                        index +
                                                                            1)
                                                                    .firstWhere(
                                                                        (element) =>
                                                                            element.type ==
                                                                            "REFUEL")).toStringAsFixed(
                                                                2) +
                                                            "l/100km",
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14.0),
                                                      )
                                                    ],
                                                    if (data[index].type ==
                                                        "EXPENSE") ...[
                                                      Text(
                                                        data[index].note,
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14.0),
                                                      ),
                                                    ]
                                                  ],
                                                ),
                                              )
                                            ],
                                          )));
                                }));
                      } else {
                        return InkWell(
                            child: Container(
                                padding: const EdgeInsets.only(top: 4),
                                child: ListView.separated(
                                    itemCount: data.length,
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(height: 4),
                                    itemBuilder:
                                        (BuildContext conext, int index) {
                                      return Container(
                                          padding: const EdgeInsets.only(
                                              top: 10, bottom: 10),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(10),
                                                      topRight:
                                                          Radius.circular(10),
                                                      bottomLeft:
                                                          Radius.circular(10),
                                                      bottomRight:
                                                          Radius.circular(10)),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.5),
                                                    spreadRadius: 5,
                                                    blurRadius: 7,
                                                    offset: const Offset(0, 3))
                                              ]),
                                          child: Row(
                                            children: [
                                              Container(
                                                height: 115,
                                                width: 150,
                                                padding: const EdgeInsets.only(
                                                    top: 15,
                                                    left: 15,
                                                    right: 15),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      DateFormat(
                                                              'dd-MM-yyyy\nHH:mm:ss')
                                                          .format(
                                                              data[index].date),
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14.0),
                                                    ),
                                                    Text(
                                                      vehicleValue,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14.0),
                                                    ),
                                                    IconButton(
                                                      icon: const Icon(
                                                          EvaIcons.trash),
                                                      onPressed: () {
                                                        if (data[index].type ==
                                                            "REFUEL") {
                                                          refuelRepository
                                                              .removeRefuel(
                                                                  data[index]
                                                                      .id);
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(const SnackBar(
                                                                  content: Text(
                                                                      "Refuel deleted."),
                                                                  backgroundColor:
                                                                      Colors
                                                                          .green));
                                                          setState(() {});
                                                        } else if (data[index]
                                                                .type ==
                                                            "EXPENSE") {
                                                          expanseRepository
                                                              .removeExpense(
                                                                  data[index]
                                                                      .id);
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(const SnackBar(
                                                                  content: Text(
                                                                      "Expense deleted."),
                                                                  backgroundColor:
                                                                      Colors
                                                                          .green));
                                                          setState(() {});
                                                        }
                                                      },
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                height: 100,
                                                width: 240,
                                                padding: const EdgeInsets.only(
                                                    top: 15, left: 60),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      data[index]
                                                              .odometer
                                                              .toString() +
                                                          " km",
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14.0),
                                                    ),
                                                    if (data[index].type ==
                                                        "REFUEL") ...[
                                                      Text(
                                                        data[index].fuel +
                                                            "kwh)",
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14.0),
                                                      ),
                                                      Text(
                                                        data[index].price +
                                                            "zl/kwh",
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14.0),
                                                      )
                                                    ],
                                                    Text(
                                                      data[index].totalCost,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14.0),
                                                    ),
                                                    if (data
                                                                .where((element) =>
                                                                    element
                                                                        .type ==
                                                                    "REFUEL")
                                                                .toList()
                                                                .length >
                                                            1 &&
                                                        data
                                                                .lastWhere(
                                                                    (element) =>
                                                                        element
                                                                            .type ==
                                                                        "REFUEL")
                                                                .id !=
                                                            data[index].id &&
                                                        data[index].type ==
                                                            "REFUEL") ...[
                                                      Text(
                                                        avg(
                                                                data[index],
                                                                data
                                                                    .sublist(
                                                                        index +
                                                                            1)
                                                                    .firstWhere(
                                                                        (element) =>
                                                                            element.type ==
                                                                            "REFUEL")).toStringAsFixed(
                                                                2) +
                                                            "kwh/100km",
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14.0),
                                                      )
                                                    ],
                                                    if (data[index].type ==
                                                        "EXPENSE") ...[
                                                      Text(
                                                        data[index].note,
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14.0),
                                                      ),
                                                    ]
                                                  ],
                                                ),
                                              )
                                            ],
                                          ));
                                    })));
                      }
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }

                    return const CircularProgressIndicator();
                  },
                )),
                floatingActionButton: ExpandableFab(distance: 125, children: [
                  FloatingActionButton.extended(
                      heroTag: "btn1",
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddRefuelScreen(
                                      refuelRepository: refuelRepository,
                                      carName: vehicleValue,
                                      vehicleType: vehicleType,
                                      lastOdometer: lastOdometer,
                                      atHome: false,
                                      latidiude: latidude,
                                      longtitiude: longtitude,
                                    ))).then((_) => setState(() {}));
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Add refuel'),
                      backgroundColor: style.Colors.mainColor),
                  FloatingActionButton.extended(
                      heroTag: "btn2",
                      onPressed: () {
                        Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddExpenseScreen(
                                        expenseRepository: expanseRepository,
                                        carName: vehicleValue,
                                        lastOdometer: lastOdometer)))
                            .then((_) => setState(() {}));
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Add expense'),
                      backgroundColor: style.Colors.mainColor),
                ]),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerFloat);
          } else {
            return Scaffold(
                appBar: AppBar(
                  backgroundColor: style.Colors.mainColor,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const VehicleScreen()))
                                .then((_) => setState(() {}));
                          },
                          icon: const Icon(EvaIcons.fileAdd)),
                      const SizedBox(width: 55),
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
                body: const Center(child: Text("Please add vehicle")));
          }
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
