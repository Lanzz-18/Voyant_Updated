import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:voyant/screens/quest/views/quest_start_screen.dart';

class Map extends StatefulWidget {
  const Map({super.key});

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  late GoogleMapController mapController;
  final Set<Marker> _markers = {};
  bool _isDarkMode = true;
  String? _selectedMarkerId;
  late OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _overlayEntry = null;
    _initializeMarkers();
  }

  void _initializeMarkers() {
    _markers.addAll([
      Marker(
        markerId: const MarkerId('colombo'),
        position: const LatLng(6.9271, 79.8612),
        infoWindow: const InfoWindow(title: ''),
        onTap: () => _showCustomInfoWindow(
          'Colombo',
          'Capital of Sri Lanka',
        ),
      ),
      Marker(
        markerId: const MarkerId('kandy'),
        position: const LatLng(7.2906, 80.6337),
        infoWindow: const InfoWindow(title: ''),
        onTap: () => _showCustomInfoWindow(
          'Kandy',
          'Cultural center of Sri Lanka',
        ),
      ),
      Marker(
        markerId: const MarkerId('galle'),
        position: const LatLng(6.024782559149793, 80.2180335396037),
        infoWindow: const InfoWindow(title: ''),
        onTap: _onGalleMarkerTapped,
      ),
    ]);
  }

  void _showCustomInfoWindow(String title, String snippet) {
    _removeCustomInfoWindow();
    
    final overlay = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 100,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF4C1D95),
                  const Color(0xFF7C3AED),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  snippet,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    
    overlay.insert(_overlayEntry!);
  }

  void _removeCustomInfoWindow() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _onGalleMarkerTapped() {
    _showCustomInfoWindow(
      'Galle',
      'Historic coastal city',
    );
    
    Future.delayed(const Duration(milliseconds: 500), () {
      _removeCustomInfoWindow();
      if (mounted) {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => DraggableScrollableSheet(
            initialChildSize: 0.5,
            minChildSize: 0.3,
            maxChildSize: 0.95,
            builder: (context, scrollController) => const QuestStartScreen(
              questTitle: 'Quest Started',
            ),
          ),
        );
      }
    });
  }

  Future<void> _setMapStyle() async {
    if (_isDarkMode) {
      final String darkMapStyle = await DefaultAssetBundle.of(context)
          .loadString('assets/map_styles/dark_map.json');
      await mapController.setMapStyle(darkMapStyle);
    } else {
      await mapController.setMapStyle(null); // Reset to default light style
    }
  }

  



  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _setMapStyle(); // Apply the map style when the map is created
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        onTap: (_) => _removeCustomInfoWindow(),
        initialCameraPosition: const CameraPosition(
          target: LatLng(7.8731, 80.7718), // Sri Lanka coordinates
          zoom: 7,
        ),
        markers: _markers,
        zoomControlsEnabled: true,
        compassEnabled: true,
        mapToolbarEnabled: true,
      ),
    
    );
  }

  @override
  void dispose() {
    _removeCustomInfoWindow();
    mapController.dispose();
    super.dispose();
  }
}