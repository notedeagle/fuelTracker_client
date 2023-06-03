import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RefuelMapScreen extends StatefulWidget {
  final double latitude;
  final double longitude;

  const RefuelMapScreen(
      {Key? key, required this.latitude, required this.longitude})
      : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() =>
      // ignore: no_logic_in_create_state
      _RefuelMapState(latitude, longitude);
}

class _RefuelMapState extends State<RefuelMapScreen> {
  final double latitude;
  final double longitude;

  _RefuelMapState(this.latitude, this.longitude);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition:
            CameraPosition(target: LatLng(latitude, longitude), zoom: 14.5),
        markers: {
          Marker(
            onTap: () {
              debugPrint('Tapped');
            },
            markerId: const MarkerId("source"),
            position: LatLng(latitude, longitude),
          ),
        },
      ),
    );
  }
}
