import 'package:bateria_mobile/models/google_maps/maps_address.dart';
import 'package:bateria_mobile/models/google_maps/maps_geometry.dart';
import 'package:bateria_mobile/models/google_maps/maps_location.dart';
import 'package:bateria_mobile/models/google_maps/maps_viewport.dart';
import 'package:bateria_mobile/views/search/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

final myLocationDisabled = StateProvider((ref) => false);

class SearchByLocationButton extends ConsumerWidget {
  const SearchByLocationButton({Key? key}) : super(key: key);

  Future<Position?> _getLocation(WidgetRef ref) async {
    final enabled = await Geolocator.isLocationServiceEnabled();

    if (!enabled) {
      // TODO Display a warning to the user about it.
      return Future.error('Location services aren\'t enabled.');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        // TODO Show a message to the user explaining why location access is needed.
        return Future.error('Location services are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Make the button search by location disabled, since the permission was denied forever.
      ref.read(myLocationDisabled.state).state = true;

      return Future.error('Location permissions are permanently denied.');
    }

    return Geolocator.getCurrentPosition();
  }

  void _focusMyLocation(WidgetRef ref) async {
    final location = await _getLocation(ref);

    if (location == null) {
      // The location couldn't be retrieved and the error handling
      // should be done by `_getLocation` already.
      return;
    }

    const locationAccuracy = 0.006;

    final northeast = MapsLocation(
      lat: location.latitude + locationAccuracy,
      lng: location.longitude + locationAccuracy,
    );
    final southwest = MapsLocation(
      lat: location.latitude - locationAccuracy,
      lng: location.longitude - locationAccuracy,
    );

    ref.read(currentMapsAddress.state).state = MapsAddress(
      name: 'Current location',
      geometry: MapsGeometry(
        location: MapsLocation(
          lat: location.latitude,
          lng: location.longitude,
        ),
        viewport: MapsViewport(northeast: northeast, southwest: southwest),
      ),
    );

    // TODO Show a toast to let the user know the current location has been used.
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final disabled = ref.watch(myLocationDisabled);

    return Tooltip(
      message: 'Buscar por localização atual',
      child: IconButton(
        onPressed: disabled
            ? null
            : () {
                _focusMyLocation(ref);
              },
        icon: const Icon(Icons.my_location_sharp),
      ),
    );
  }
}
