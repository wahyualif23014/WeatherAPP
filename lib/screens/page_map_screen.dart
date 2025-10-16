import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MapPage extends StatefulWidget {
  final double initialLat;
  final double initialLng;

  const MapPage({Key? key, this.initialLat = -6.2, this.initialLng = 106.8})
      : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;
  late LatLng _currentLocation;
  late Set<Marker> _markers = {};
  late List<FavoriteLocation> favoriteLocations = [];
  late String openWeatherKey;

  final TextEditingController _searchController = TextEditingController();

  // for animation marker
  late Map<MarkerId, double> _markerAnimations = {};
  final Duration _animationDuration = Duration(milliseconds: 600);

  @override
  void initState() {
    super.initState();
    openWeatherKey = dotenv.env['OPEN_WEATHER_API_KEY']!;
    _currentLocation = LatLng(widget.initialLat, widget.initialLng);
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final favsJson = prefs.getStringList("favorites") ?? [];

    setState(() {
      favoriteLocations = favsJson.map((json) {
        final parts = json.split(",");
        return FavoriteLocation(
          name: parts[0],
          lat: double.parse(parts[1]),
          lng: double.parse(parts[2]),
        );
      }).toList();

      _markers.clear();
      _markerAnimations.clear();

      for (var loc in favoriteLocations) {
        final markerId = MarkerId("${loc.name}-${loc.lat},${loc.lng}");
        _markerAnimations[markerId] = 0.0;

        _markers.add(Marker(
          markerId: markerId,
          position: LatLng(loc.lat, loc.lng),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(title: loc.name),
          onTap: () => _showWeatherDialog(context, loc.lat, loc.lng),
        ));

        Future.delayed(_animationDuration * (_markers.length ~/ 2), () {
          if (mounted) {
            setState(() {
              _markerAnimations[markerId] = 1.0;
            });
          }
        });
      }
    });
  }

  Future<void> _saveFavorite(FavoriteLocation location) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList("favorites") ?? [];
    final newEntry = "${location.name},${location.lat},${location.lng}";

    if (!existing.contains(newEntry)) {
      existing.add(newEntry);
      await prefs.setStringList("favorites", existing);

      final markerId = MarkerId("${location.name}-${location.lat},${location.lng}");

      setState(() {
        favoriteLocations.add(location);
        _markerAnimations[markerId] = 0.0;

        _markers.add(Marker(
          markerId: markerId,
          position: LatLng(location.lat, location.lng),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(title: location.name),
          onTap: () => _showWeatherDialog(context, location.lat, location.lng),
        ));
      });

      await Future.delayed(_animationDuration ~/ 2);

      if (mounted) {
        setState(() {
          _markerAnimations[markerId] = 1.0;
        });
      }
    }

    Navigator.pop(context);
  }

  Future<void> _removeFavorite(FavoriteLocation location) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList("favorites") ?? [];
    final entryToRemove = "${location.name},${location.lat},${location.lng}";
    existing.remove(entryToRemove);
    await prefs.setStringList("favorites", existing);

    setState(() {
      favoriteLocations.remove(location);
      _markers.removeWhere((marker) =>
          marker.position.latitude == location.lat &&
          marker.position.longitude == location.lng);
    });
  }

  Future<void> _updateFavorite(int index, FavoriteLocation updatedLoc) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList("favorites") ?? [];

    final oldEntry =
        "${favoriteLocations[index].name},${favoriteLocations[index].lat},${favoriteLocations[index].lng}";
    final newEntry = "${updatedLoc.name},${updatedLoc.lat},${updatedLoc.lng}";

    int pos = existing.indexOf(oldEntry);
    if (pos != -1) {
      existing[pos] = newEntry;
      await prefs.setStringList("favorites", existing);
      _loadFavorites();
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _moveTo(LatLng latLng) {
    mapController.animateCamera(CameraUpdate.newLatLngZoom(latLng, 10));
  }

  void _showAddFavoriteDialog(BuildContext context, LatLng latLng) {
    TextEditingController nameController = TextEditingController(text: "New location");

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Save Favorite Location"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Location Name"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                _saveFavorite(FavoriteLocation(
                  name: nameController.text,
                  lat: latLng.latitude,
                  lng: latLng.longitude,
                ));
              }
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }

  void _showEditFavoriteDialog(BuildContext context, int index) {
    TextEditingController nameController =
        TextEditingController(text: favoriteLocations[index].name);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Change Favorite Location Name"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "New Location Name"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                _updateFavorite(index, FavoriteLocation(
                  name: nameController.text,
                  lat: favoriteLocations[index].lat,
                  lng: favoriteLocations[index].lng,
                ));
                Navigator.pop(context);
              }
            },
            child: Text("Update"),
          ),
        ],
      ),
    );
  }

  void _showWeatherDialog(BuildContext context, double lat, double lng) async {
    final weatherData = await fetchWeather(lat, lng);
    if (weatherData != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(weatherData["name"]),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Suhu: ${_kelvinToCelsius(weatherData["main"]["temp"])}°C"),
              Text("Deskripsi: ${weatherData["weather"][0]["description"]}"),
              Text("Kelembapan: ${weatherData["main"]["humidity"]}%"),
              Text("Angin: ${weatherData["wind"]["speed"]} m/s"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: Text("Close"),
            )
          ],
        ),
      );
    }
  }

  Future<Map<String, dynamic>?> fetchWeather(double lat, double lng) async {
    final url =
        "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lng&appid=$openWeatherKey";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Gagal mengambil data cuaca"),
      ));
      return null;
    }
  }

  Future<void> _searchCity(String cityName) async {
    final url =
        "http://api.openweathermap.org/geo/1.0/direct?q=$cityName&limit=1&appid=$openWeatherKey";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200 && response.body != "[]") {
      final result = json.decode(response.body)[0];
      final lat = result["lat"];
      final lon = result["lon"];
      final name = result["name"];

      setState(() {
        _currentLocation = LatLng(lat, lon);
        _moveTo(_currentLocation);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Location Found: $name")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Location not found")),
      );
    }
  }

  double _kelvinToCelsius(double kelvin) => kelvin - 273.15;

  void _showBottomSheetForFavorites(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Favorite Locations",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Divider(),
              if (favoriteLocations.isEmpty)
                Text("No favorite locations saved")
              else
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: favoriteLocations.length,
                  itemBuilder: (context, index) {
                    final loc = favoriteLocations[index];
                    return ListTile(
                      leading: Icon(Icons.location_on, color: Colors.red),
                      title: Text(loc.name),
                      subtitle: Text("${loc.lat}, ${loc.lng}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit_outlined),
                            onPressed: () => _showEditFavoriteDialog(context, index),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete_outline),
                            onPressed: () => _removeFavorite(loc),
                          ),
                        ],
                      ),
                      onTap: () => _moveTo(LatLng(loc.lat, loc.lng)),
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Map Page"),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_outline),
            onPressed: () => _showBottomSheetForFavorites(context),
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _currentLocation,
              zoom: 10,
            ),
            markers: _markers.map((marker) {
              final opacity = _markerAnimations[marker.markerId] ?? 1.0;
              return _buildAnimatedMarker(marker, opacity);
            }).toSet(),
            onTap: (latLng) {
              _showAddFavoriteDialog(context, latLng);
            },
          ),
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Icon(Icons.search),
                    SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: "Search city...",
                          border: InputBorder.none,
                        ),
                        onSubmitted: (value) {
                          if (value.isNotEmpty) {
                            _searchCity(value);
                          }
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () {
                        if (_searchController.text.isNotEmpty) {
                          _searchCity(_searchController.text);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _moveTo(_currentLocation),
        child: Icon(Icons.my_location),
      ),
    );
  }

  Marker _buildAnimatedMarker(Marker marker, double opacity) {
    return marker.copyWith(
      iconParam: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      consumeTapEventsParam: opacity >= 0.8,
      alphaParam: opacity,
    );
  }
}

class FavoriteLocation {
  final String name;
  final double lat;
  final double lng;

  FavoriteLocation({
    required this.name,
    required this.lat,
    required this.lng,
  });

  @override
  String toString() => "$name,$lat,$lng";
}