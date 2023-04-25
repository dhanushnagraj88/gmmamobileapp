import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../helpers/location_helper.dart';
import '../screens/map_screen.dart';

class UserLocationPicker extends StatefulWidget {
  const UserLocationPicker({
    Key? key,
    required this.onSelectPlace,
  }) : super(key: key);

  final Function onSelectPlace;

  @override
  State<UserLocationPicker> createState() => _UserLocationPickerState();
}

class _UserLocationPickerState extends State<UserLocationPicker> {
  String? _previewImageUrl;

  void _showPreview(double lat, double long) {
    final staticMapImage = LocationHelper.generateLocationPreviewImage(
      latitude: lat,
      longitude: long,
    );
    setState(() {
      _previewImageUrl = staticMapImage;
    });
  }

  Future<void> _getCurrentUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are denied permanently');
    }

    final currentPosition = await Geolocator.getCurrentPosition();
    _showPreview(currentPosition.latitude, currentPosition.longitude);
    widget.onSelectPlace(
      currentPosition.latitude,
      currentPosition.longitude,
    );
  }

  Future<void> _selectOnMap() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are denied permanently');
    }
    final currentPosition = await Geolocator.getCurrentPosition();
    final selectedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => MapScreen(
          isSelecting: true,
          initialLocation: LatLng(
            currentPosition.latitude,
            currentPosition.longitude,
          ),
        ),
      ),
    );
    _showPreview(selectedLocation!.latitude, selectedLocation.longitude);
    widget.onSelectPlace(
      selectedLocation.latitude,
      selectedLocation.longitude,
    );
    if (selectedLocation == null) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          height: 150,
          width: double.infinity,
          child: _previewImageUrl == null
              ? const Text(
                  'No location Chosen',
                  textAlign: TextAlign.center,
                )
              : Image.network(
                  _previewImageUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 1,
                ),
              ),
              onPressed: _getCurrentUserLocation,
              icon: const Icon(Icons.location_on),
              label: const Text('Current Location'),
            ),
            TextButton.icon(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 1,
                ),
              ),
              onPressed: _selectOnMap,
              icon: const Icon(Icons.map),
              label: const Text('Select on Map'),
            ),
          ],
        ),
      ],
    );
  }
}
