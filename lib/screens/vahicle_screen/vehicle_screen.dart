import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tracker_client/bloc/auth_bloc/auth.dart';
import 'package:flutter_tracker_client/dto/vehicle_dto.dart';
import 'package:flutter_tracker_client/repositories/repositories.dart';
import 'package:flutter_tracker_client/screens/vahicle_screen/add_vehicle_screen.dart';
import 'package:flutter_tracker_client/style/theme.dart' as style;

class VehicleScreen extends StatefulWidget {
  const VehicleScreen({Key? key}) : super(key: key);

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
              // endDrawer: Drawer(
              //   child: ListView(
              //     padding: EdgeInsets.zero,
              //     children: [
              //       const DrawerHeader(
              //         decoration: BoxDecoration(color: style.Colors.mainColor),
              //         child: Text(""),
              //       ),
              //       ListTile(
              //         leading: const Icon(EvaIcons.logOutOutline),
              //         title: const Text("Log out"),
              //         onTap: () {
              //           BlocProvider.of<AuthenticationBloc>(context).add(
              //             LoggedOut(),
              //           );
              //         },
              //       )
              //     ],
              //   ),
              // ),
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
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      SizedBox(width: 80),
                      Text("Vehicles"),
                    ],
                  )),
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
                                              data[index].name,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14.0),
                                            ),
                                            Text(
                                              data[index].brand,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14.0),
                                            ),
                                            Text(
                                              data[index].model,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14.0),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: 115,
                                        width: 190,
                                        padding: const EdgeInsets.only(
                                            top: 15, left: 60),
                                        child: Column(
                                          children: [
                                            Text(
                                              data[index].plateNumber,
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
                                            ),
                                            Text(
                                              data[index].vehicleType,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14.0),
                                            ),
                                            IconButton(
                                              icon: const Icon(EvaIcons.trash),
                                              onPressed: () {
                                                vehicleRepository.removeVehicle(
                                                    data[index].name);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(const SnackBar(
                                                        content: Text(
                                                            "Vehicle deleted."),
                                                        backgroundColor:
                                                            Colors.green));
                                                setState(() {});
                                              },
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
              )),
              floatingActionButton: FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddVehicleScreen(
                                    vehicleRepository: vehicleRepository)))
                        .then((_) => setState(() {}));
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add'),
                  backgroundColor: style.Colors.mainColor),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat);
        });
  }
}
