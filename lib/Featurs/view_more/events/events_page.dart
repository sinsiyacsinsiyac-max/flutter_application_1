import 'package:flutter/material.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({Key? key}) : super(key: key);

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final List<Map<String, dynamic>> upcomingEvents = [
    {
      
      'title': 'Tech Conference 2024',
      'date': 'Dec 15, 2024',
      'time': '10:00 AM - 5:00 PM',
      'location': 'Convention Center',
      'type': 'Conference',
      'icon': Icons.computer,
      'color': const Color(0xFF283593),
    },
    {
      'title': 'Workshop: Flutter Development',
      'date': 'Dec 20, 2024',
      'time': '2:00 PM - 4:00 PM',
      'location': 'Room 301',
      'type': 'Workshop',
      'icon': Icons.code,
      'color': const Color(0xFF1565C0),
    },
    {
      'title': 'Annual Meetup',
      'date': 'Dec 25, 2024',
      'time': '6:00 PM - 9:00 PM',
      'location': 'Grand Hall',
      'type': 'Meetup',
      'icon': Icons.groups,
      'color': const Color(0xFF6A1B9A),
    },
    {
      'title': 'Guest Lecture: AI & ML',
      'date': 'Jan 5, 2025',
      'time': '11:00 AM - 1:00 PM',
      'location': 'Auditorium A',
      'type': 'Lecture',
      'icon': Icons.mic,
      'color': const Color(0xFFD32F2F),
    },
    {
      'title': 'Guest Lecture: AI & ML',
      'date': 'Jan 5, 2025',
      'time': '11:00 AM - 1:00 PM',
      'location': 'Auditorium A',
      'type': 'Lecture',
      'icon': Icons.mic,
      'color': const Color(0xFFD32F2F),
    },
  ];

  final List<Map<String, dynamic>> pastEvents = [
    {
      'title': 'Hackathon 2024',
      'date': 'Nov 10, 2024',
      'location': 'Tech Park',
      'type': 'Hackathon',
      'icon': Icons.terminal,
      'color': Colors.grey,
    },
    {
      'title': 'Cultural Fest',
      'date': 'Oct 28, 2024',
      'location': 'Main Campus',
      'type': 'Festival',
      'icon': Icons.celebration,
      'color': Colors.grey,
    },
  ];

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
          // Events List
          Expanded(
            child: selectedTab == 'Upcoming'
                ? _buildEventsList(upcomingEvents, isUpcoming: true)
                : _buildEventsList(pastEvents, isUpcoming: false),
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

  Widget _buildEventsList(List<Map<String, dynamic>> events, {required bool isUpcoming}) {
    if (events.isEmpty) {
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
              'No ${isUpcoming ? "upcoming" : "past"} events',
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

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: events.length,
      itemBuilder: (context, index) {
        return _buildEventCard(events[index], isUpcoming);
      },
    );
  }

  Widget _buildEventCard(Map<String, dynamic> event, bool isUpcoming) {
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
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: event['color'].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      event['icon'],
                      color: event['color'],
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event['title'],
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
                            color: event['color'].withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            event['type'],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: event['color'],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildEventDetail(Icons.calendar_today, event['date']),
              if (isUpcoming) ...[
                const SizedBox(height: 8),
                _buildEventDetail(Icons.access_time, event['time']),
              ],
              const SizedBox(height: 8),
              _buildEventDetail(Icons.location_on, event['location']),
              if (isUpcoming) ...[
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _showRegistrationConfirmation(event['title']);
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

  void _showEventDetails(Map<String, dynamic> event) {
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
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: event['color'].withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        event['icon'],
                        color: event['color'],
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        event['title'],
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
                _buildDetailRow(Icons.event, 'Type', event['type']),
                _buildDetailRow(Icons.calendar_today, 'Date', event['date']),
                if (event.containsKey('time'))
                  _buildDetailRow(Icons.access_time, 'Time', event['time']),
                _buildDetailRow(Icons.location_on, 'Location', event['location']),
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
                  'Join us for an exciting ${event['type'].toLowerCase()} that brings together enthusiasts and professionals. This event promises to be an enriching experience with networking opportunities and valuable insights.',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                ),
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