import 'package:flutter/material.dart';

class AmenityDetailsPage extends StatelessWidget {
  final Map<String, dynamic> amenity;

  const AmenityDetailsPage({Key? key, required this.amenity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final name = amenity['name'] ?? 'Unnamed Facility';
    final category = amenity['category'] ?? 'Other';
    final description = amenity['description'] ?? 'No description available.';
    final location = amenity['location'] ?? 'N/A';
    final capacity = amenity['capacity'] ?? 'N/A';
    final timings = amenity['timings'] ?? 'N/A';
    final contact = amenity['contact'] ?? 'N/A';
    final isAvailable = amenity['available'] == true;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context, name, category),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAvailabilityBadge(isAvailable),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Description'),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[800],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildSectionTitle('Facility Details'),
                  const SizedBox(height: 16),
                  _buildDetailGrid(location, capacity, timings, contact),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, String name, String category) {
    return SliverAppBar(
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: _getAmenityColor(category),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              category,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    _getAmenityColor(category).withOpacity(0.4),
                    _getAmenityColor(category),
                  ],
                ),
              ),
            ),
            Center(
              child: Opacity(
                opacity: 0.2,
                child: Icon(
                  _getAmenityIcon(category),
                  size: 100,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvailabilityBadge(bool isAvailable) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isAvailable ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: isAvailable ? Colors.green.withOpacity(0.5) : Colors.red.withOpacity(0.5),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isAvailable ? Icons.check_circle_rounded : Icons.cancel_rounded,
            size: 18,
            color: isAvailable ? Colors.green[700] : Colors.red[700],
          ),
          const SizedBox(width: 8),
          Text(
            isAvailable ? 'OPEN FOR USE' : 'TEMPORARILY CLOSED',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isAvailable ? Colors.green[700] : Colors.red[700],
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1A237E),
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildDetailGrid(String location, String capacity, String timings, String contact) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double cardWidth = (constraints.maxWidth - 16) / 2;
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _buildDetailCard('Location', location, Icons.location_on_rounded, Colors.blue, cardWidth),
            _buildDetailCard('Capacity', capacity, Icons.people_rounded, Colors.purple, cardWidth),
            _buildDetailCard('Operating Hours', timings, Icons.access_time_filled_rounded, Colors.orange, cardWidth),
            _buildDetailCard('Contact', contact, Icons.phone_android_rounded, Colors.green, cardWidth),
          ],
        );
      },
    );
  }

  Widget _buildDetailCard(String label, String value, IconData icon, Color color, double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Color _getAmenityColor(String category) {
    switch (category) {
      case 'Library': return const Color(0xFF1976D2);
      case 'Sports': return const Color(0xFFF57C00);
      case 'Laboratory': return const Color(0xFF7B1FA2);
      case 'Cafeteria': return const Color(0xFF5D4037);
      case 'Auditorium': return const Color(0xFF303F9F);
      case 'Hostel': return const Color(0xFF00796B);
      case 'Transport': return const Color(0xFFFFA000);
      case 'Medical': return const Color(0xFFD32F2F);
      default: return const Color(0xFF455A64);
    }
  }

  IconData _getAmenityIcon(String category) {
    switch (category) {
      case 'Library': return Icons.local_library;
      case 'Sports': return Icons.sports_basketball;
      case 'Laboratory': return Icons.science;
      case 'Cafeteria': return Icons.restaurant;
      case 'Auditorium': return Icons.theater_comedy;
      case 'Hostel': return Icons.hotel;
      case 'Transport': return Icons.directions_bus;
      case 'Medical': return Icons.local_hospital;
      default: return Icons.apartment;
    }
  }
}
