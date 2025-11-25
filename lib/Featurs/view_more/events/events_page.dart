import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({Key? key}) : super(key: key);

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String selectedTab = 'Upcoming';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF283593),
        title: const Text(
          'Events',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
      ),
      body: Column(
        children: [
          // Tab Selector
          Container(
            color: const Color(0xFF283593),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: _buildTabButton('Upcoming'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTabButton('Past'),
                  ),
                ],
              ),
            ),
          ),
          // Events List from Firestore
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('events')
                  .orderBy('eventDateTime', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return _buildEmptyState();
                }

                final events = _filterEvents(snapshot.data!.docs);
                return _buildEventsList(events);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String title) {
    final isSelected = selectedTab == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? const Color(0xFF283593) : Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  List<QueryDocumentSnapshot> _filterEvents(List<QueryDocumentSnapshot> events) {
    final now = DateTime.now();
    
    return events.where((doc) {
      final event = doc.data() as Map<String, dynamic>;
      final eventDateTime = (event['eventDateTime'] as Timestamp).toDate();
      
      if (selectedTab == 'Upcoming') {
        return eventDateTime.isAfter(now);
      } else {
        return eventDateTime.isBefore(now);
      }
    }).toList();
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No ${selectedTab.toLowerCase()} events',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventsList(List<QueryDocumentSnapshot> events) {
    if (events.isEmpty) {
      return Center(
        child: Text(
          'No ${selectedTab.toLowerCase()} events',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final eventDoc = events[index];
        final event = eventDoc.data() as Map<String, dynamic>;
        return _buildEventCard(event);
      },
    );
  }

  Widget _buildEventCard(Map<String, dynamic> event) {
    final eventDateTime = (event['eventDateTime'] as Timestamp).toDate();
    final isUpcoming = eventDateTime.isAfter(DateTime.now());
    final images = event['imageUrls'] as List<dynamic>? ?? [];

    return Card(
      elevation: 3,
      shadowColor: Colors.black12,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          _showEventDetails(event);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Event Image or Icon
                  _buildEventImage(event, images),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event['name'] ?? 'Event',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0F1A6E),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getEventColor(event['category']).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            event['category'] ?? 'Event',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: _getEventColor(event['category']),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildEventDetail(Icons.calendar_today, event['date'] ?? ''),
              const SizedBox(height: 8),
              _buildEventDetail(Icons.access_time, event['time'] ?? ''),
              const SizedBox(height: 8),
              _buildEventDetail(Icons.location_on, event['venue'] ?? ''),
              if (isUpcoming) ...[
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _showRegistrationConfirmation(event['name']);
                    },
                    icon: const Icon(Icons.check_circle, size: 18),
                    label: const Text('Register'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF283593),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventImage(Map<String, dynamic> event, List<dynamic> images) {
    if (images.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          images.first,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildPlaceholderIcon(event['category']);
          },
        ),
      );
    }
    
    return _buildPlaceholderIcon(event['category']);
  }

  Widget _buildPlaceholderIcon(String? category) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: _getEventColor(category),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        _getEventIcon(category),
        color: Colors.white,
        size: 30,
      ),
    );
  }

  Widget _buildEventDetail(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
        ),
      ],
    );
  }

  Color _getEventColor(String? category) {
    switch (category) {
      case 'Cultural':
        return Colors.purple.shade700;
      case 'Technical':
        return Colors.blue.shade700;
      case 'Sports':
        return Colors.green.shade700;
      case 'Workshop':
        return Colors.orange.shade700;
      case 'Seminar':
        return Colors.teal.shade700;
      default:
        return Colors.grey.shade700;
    }
  }

  IconData _getEventIcon(String? category) {
    switch (category) {
      case 'Cultural':
        return Icons.music_note;
      case 'Technical':
        return Icons.computer;
      case 'Sports':
        return Icons.sports_basketball;
      case 'Workshop':
        return Icons.build;
      case 'Seminar':
        return Icons.person;
      default:
        return Icons.event;
    }
  }

  void _showEventDetails(Map<String, dynamic> event) {
    final images = event['imageUrls'] as List<dynamic>? ?? [];
    final eventDateTime = (event['eventDateTime'] as Timestamp).toDate();
    final isUpcoming = eventDateTime.isAfter(DateTime.now());

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Event Image
                if (images.isNotEmpty)
                  Container(
                    height: 200,
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: NetworkImage(images.first),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _getEventColor(event['category']).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        _getEventIcon(event['category']),
                        color: _getEventColor(event['category']),
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        event['name'] ?? 'Event',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F1A6E),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'Event Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F1A6E),
                  ),
                ),
                const SizedBox(height: 16),
                _buildDetailRow(Icons.category, 'Category', event['category'] ?? ''),
                _buildDetailRow(Icons.calendar_today, 'Date', event['date'] ?? ''),
                _buildDetailRow(Icons.access_time, 'Time', event['time'] ?? ''),
                _buildDetailRow(Icons.location_on, 'Location', event['venue'] ?? ''),
                
                if (event['description'] != null && event['description'].isNotEmpty) ...[
                  const SizedBox(height: 24),
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0F1A6E),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    event['description'] ?? '',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                ],
                
                // Image Gallery
                if (images.length > 1) ...[
                  const SizedBox(height: 24),
                  const Text(
                    'Event Gallery',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0F1A6E),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: images.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(right: 8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              images[index],
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
                
                if (isUpcoming) ...[
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _showRegistrationConfirmation(event['name']);
                      },
                      icon: const Icon(Icons.check_circle, size: 20),
                      label: const Text(
                        'Register for Event',
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF283593),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF283593)),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showRegistrationConfirmation(String eventTitle) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Confirm Registration'),
        content: Text('Do you want to register for "$eventTitle"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Successfully registered for $eventTitle'),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF283593),
            ),
            child: const Text('Register'),
          ),
        ],
      ),
    );
  }
}