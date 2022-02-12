// ignore_for_file: unnecessary_const

import 'package:auto_size_text/auto_size_text.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tracker_client/dto/refuel_dto.dart';
import 'package:flutter_tracker_client/repositories/repositories.dart';
import 'package:flutter_tracker_client/screens/vahicle_screen/vehicle_screen.dart';
import 'package:flutter_tracker_client/style/theme.dart' as style;
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class RaportScreen extends StatefulWidget {
  final String carName;
  final String vehicleType;

  const RaportScreen(
      {Key? key, required this.carName, required this.vehicleType})
      : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() =>
      // ignore: no_logic_in_create_state
      _RaportScreenState(carName: carName, vehicleType: vehicleType);
}

class _RaportScreenState extends State<RaportScreen> {
  var refuelRepository = RefuelRepository();
  String carName;
  String vehicleType;
  late String unit;
  late String unit2;

  _RaportScreenState({required this.carName, required this.vehicleType});

  sumCost(List<RefuelDto> list) {
    double sum = 0;

    for (var element in list) {
      sum += element.totalCost;
    }

    return sum;
  }

  perDay(List<RefuelDto> list) {
    final days =
        (list.last.date.difference(list.first.date).inHours / 24).round();

    if (days == 0) {
      return 0;
    }

    return sumCost(list) / days;
  }

  perKm(List<RefuelDto> list) {
    final km = list.last.odometer - list.first.odometer;

    if (km == 0) {
      return 0;
    }

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
    list.removeAt(0);
    double sum = 0;

    if (list.length == 1) {
      return list[0].avg;
    }

    for (var element in list) {
      sum += element.avg;
    }

    return sum / list.length;
  }

  avg(RefuelDto data, RefuelDto data2) {
    final km = data.odometer - data2.odometer;

    return data.litres / km * 100;
  }

  @override
  Widget build(BuildContext context) {
    if (vehicleType == "PETROL") {
      unit = "l";
      unit2 = "l/100km";
    } else {
      unit = "kwh";
      unit2 = "kwh/100km";
    }
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
              // ListTile(
              //   leading: const Icon(EvaIcons.logOutOutline),
              //   title: const Text("Log out"),
              //   onTap: () {
              //     BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
              //   },
              // )
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
        body: Center(
            child: FutureBuilder<List<RefuelDto>>(
          future: refuelRepository.getRefuelByCarName(carName),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<RefuelDto>? data = snapshot.data;
              data!.sort((a, b) => a.date.compareTo(b.date));
              for (int i = 1; i < data.length; i++) {
                data[i].setAvg(avg(data[i], data[i - 1]));
              }
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
                      // width: 390,
                      padding:
                          const EdgeInsets.only(top: 15, left: 15, right: 15),
                      child: Center(
                          child: Text(DateFormat('dd-MM-yyyy')
                                  .format(data.first.date) +
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
                      // width: 390,
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Column(
                                  children: [
                                    const AutoSizeText(
                                      "Sum",
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 14.0),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    AutoSizeText(
                                      sumCost(data).toStringAsFixed(2) + "zl",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 65,
                              ),
                              FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Column(children: [
                                  const AutoSizeText(
                                    "Per day",
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14.0),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  AutoSizeText(
                                    perDay(data).toStringAsFixed(2) + "zl",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0),
                                  ),
                                ]),
                              ),
                              const SizedBox(
                                width: 65,
                              ),
                              FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Column(children: [
                                    const AutoSizeText(
                                      "Per km",
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 14.0),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    AutoSizeText(
                                      perKm(data).toStringAsFixed(2) + "zl",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0),
                                    ),
                                  ]))
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
                      // width: 390,
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Column(
                                    children: [
                                      const AutoSizeText(
                                        "All",
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 14.0),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      AutoSizeText(
                                        allLitres(data).toStringAsFixed(2) +
                                            unit,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0),
                                      ),
                                    ],
                                  )),
                              const SizedBox(
                                width: 65,
                              ),
                              FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Column(children: [
                                  const AutoSizeText(
                                    "Average",
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14.0),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  AutoSizeText(
                                    avgLitres(data).toStringAsFixed(2) + unit2,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0),
                                  ),
                                ]),
                              ),
                            ],
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
                      // width: 390,
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
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Flexible(
                                  child: FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Padding(
                                          padding: const EdgeInsets.all(5),
                                          child: Column(
                                            children: <Widget>[
                                              const AutoSizeText(
                                                "Last",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 14.0),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              AutoSizeText(
                                                data.last.avg
                                                        .toStringAsFixed(2) +
                                                    unit2,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14.0),
                                              ),
                                            ],
                                          ))),
                                ),
                                Flexible(
                                  child: FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Column(children: [
                                          const AutoSizeText(
                                            "Minimum",
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 14.0),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            data
                                                    .reduce((value, element) =>
                                                        value.avg < element.avg
                                                            ? value
                                                            : element)
                                                    .avg
                                                    .toStringAsFixed(2) +
                                                unit2,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14.0),
                                          ),
                                        ])),
                                  ),
                                ),
                                Flexible(
                                    child: FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: Padding(
                                          padding: const EdgeInsets.all(5),
                                          child: Column(children: [
                                            const AutoSizeText(
                                              "Maximum",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 14.0),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              data
                                                      .reduce((value,
                                                              element) =>
                                                          value.avg >
                                                                  element.avg
                                                              ? value
                                                              : element)
                                                      .avg
                                                      .toStringAsFixed(2) +
                                                  unit2,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14.0),
                                            ),
                                          ]),
                                        ))),
                              ],
                            ),
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
                      height: 240,
                      // width: 390,
                      padding:
                          const EdgeInsets.only(top: 15, left: 15, right: 15),
                      child: SfCartesianChart(
                        title: ChartTitle(
                            text: "Month total cost",
                            textStyle: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14.0)),
                        primaryXAxis: CategoryAxis(),
                        series: <ChartSeries>[
                          ColumnSeries<RefuelDto, String>(
                              dataSource: data,
                              xValueMapper: (RefuelDto refuel, _) =>
                                  DateFormat.MMMM().format(refuel.date),
                              yValueMapper: (RefuelDto refuel, _) =>
                                  refuel.totalCost)
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
                      height: 240,
                      // width: 390,
                      padding:
                          const EdgeInsets.only(top: 15, left: 15, right: 15),
                      child: SfCartesianChart(
                        title: ChartTitle(
                            text: "Price",
                            textStyle: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14.0)),
                        primaryXAxis: CategoryAxis(),
                        primaryYAxis: NumericAxis(
                            numberFormat: NumberFormat("###.00"),
                            interval: 0.1),
                        series: <ChartSeries>[
                          LineSeries<RefuelDto, String>(
                              dataSource: data,
                              xValueMapper: (RefuelDto refuel, _) =>
                                  DateFormat('dd-MM').format(refuel.date),
                              yValueMapper: (RefuelDto refuel, _) =>
                                  refuel.price)
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return const CircularProgressIndicator();
          },
        )));
  }
}
