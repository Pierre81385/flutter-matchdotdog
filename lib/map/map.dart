import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:matchdotdog/models/owner_model.dart';

import '../models/dog_model.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key, required this.owner});

  final Owner owner;
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late LatLng _initialLocation = LatLng(37.422131, -122.084801);
  late Owner _currentOwner;
  late Stream<QuerySnapshot> _allBuddiesStream;
  late int _index;

  @override
  void initState() {
    super.initState();
    _currentOwner = widget.owner;
    _index = 0;

    _allBuddiesStream = FirebaseFirestore.instance
        .collection('dogs')
        .where('owner', isNotEqualTo: _currentOwner.uid)
        .snapshots();
    _initialLocation =
        LatLng(_currentOwner.locationLat, _currentOwner.locationLong);
  }

// ToDo: add custom marker
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _allBuddiesStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text('Loading...');
        }

        final markers = snapshot.data!.docs.map((DocumentSnapshot document) {
          final lat = document['ownerLat'];
          final lng = document['ownerLong'];
          final title = document['name'];
          final markerId = MarkerId(document['id']);

          return Marker(
            markerId: markerId,
            position: LatLng(lat, lng),
            infoWindow: InfoWindow(title: title),
          );
        }).toList();

        return Scaffold(
          body: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _initialLocation,
              zoom: 14,
            ),
            markers: Set<Marker>.from(markers),
          ),
        );
      },
    );
  }
}
