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
        .collection('owners')
        .where('uid', isNotEqualTo: _currentOwner.uid)
        .snapshots();
    _initialLocation =
        LatLng(_currentOwner.locationLat, _currentOwner.locationLong);
  }

// ToDo: add custom marker
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _initialLocation,
          zoom: 14,
        ),
        markers: {
          Marker(
            markerId: const MarkerId("Me"),
            position: _initialLocation,
            draggable: true,
            onDragEnd: (value) {
              // value is the new position
            },
            // To do: custom marker icon
          ),
        },
      ),
    );
  }
}
