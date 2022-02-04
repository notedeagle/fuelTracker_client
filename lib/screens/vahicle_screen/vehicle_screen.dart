import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tracker_client/bloc/auth_bloc/auth_bloc.dart';
import 'package:flutter_tracker_client/bloc/auth_bloc/auth_event.dart';
import 'package:flutter_tracker_client/dto/vehicle_dto.dart';
import 'package:flutter_tracker_client/repositories/repositories.dart';
import 'package:flutter_tracker_client/style/theme.dart' as style;

class VehicleScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _VehicleScreenState();
}

class _VehicleScreenState extends State<VehicleScreen> {
  var vehicleRepository = VehicleRepository();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<VehicleDto>>(
        future: vehicleRepository.getCustomerVehicles(),
        builder: (context, snapshot) {
          return Scaffold(
              appBar: AppBar(
                backgroundColor: style.Colors.mainColor,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    SizedBox(width: 15),
                    Text("Fuel tracker"),
                  ],
                ),
                actions: [
                  IconButton(
                    icon: const Icon(EvaIcons.fileAdd),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (conext) => VehicleScreen()));
                    },
                  ),
                  IconButton(
                      icon: const Icon(EvaIcons.logOutOutline),
                      onPressed: () {
                        BlocProvider.of<AuthenticationBloc>(context).add(
                          LoggedOut(),
                        );
                      }),
                ],
              ),
              body: Center(
                  child: FutureBuilder<List<VehicleDto>>(
                future: VehicleRepository().getCustomerVehicles(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<VehicleDto>? data = snapshot.data;
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
                                              data[index].brand,
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
                                              data[index].mileage.toString(),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14.0),
                                            ),
                                            Text(
                                              data[index].model,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14.0),
                                            ),
                                            Text(
                                              data[index].name,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14.0),
                                            ),
                                            Text(
                                              data[index].plateNumber,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14.0),
                                            ),
                                            Text(
                                              data[index]
                                                  .registartionYear
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14.0),
                                            ),
                                            Text(
                                              data[index].vehicleType,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14.0),
                                            ),
                                            Text(
                                              data[index]
                                                  .yearOfProduction
                                                  .toString(),
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
        });
  }
}
