import 'package:flutter/material.dart';

class EventsManagementPage extends StatelessWidget {
  const EventsManagementPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Events Management',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF0F1A6E),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildEventCard(
            context,
            'Programs',
            Icons.event_rounded,
            () {
              // Navigate to Programs page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PlaceholderPage(title: 'Programs'),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildEventCard(
            context,
            'Upcoming Events',
            Icons.event_available,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PlaceholderPage(title: 'Upcoming Events'),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildEventCard(
            context,
            'Photo Gallery',
            Icons.photo_library_rounded,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PlaceholderPage(title: 'Photo Gallery'),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildEventCard(
            context,
            'Event Calendar',
            Icons.calendar_month_rounded,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PlaceholderPage(title: 'Event Calendar'),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigate to Create Event page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PlaceholderPage(title: 'Create Event'),
            ),
          );
        },
        backgroundColor: const Color(0xFF0F1A6E),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Create Event',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildEventCard(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF0F1A6E).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFF0F1A6E)),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}

// Placeholder page for demonstration
// Replace this with your actual page implementations
class PlaceholderPage extends StatelessWidget {
  final String title;

  const PlaceholderPage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFF0F1A6E),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Text(
          '$title Page',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}