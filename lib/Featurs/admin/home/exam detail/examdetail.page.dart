import 'package:flutter/material.dart';

class ExamManagementPage extends StatelessWidget {
  const ExamManagementPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Exam Management',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF283593),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildExamCard(
            context,
            'Time Table',
            Icons.calendar_today_rounded,
            onTap: () {
              // Navigate to Time Table page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PlaceholderPage(title: 'Time Table'),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildExamCard(
            context,
            'Seat Arrangements',
            Icons.event_seat_rounded,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PlaceholderPage(title: 'Seat Arrangements'),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildExamCard(
            context,
            'Exam Schedules',
            Icons.schedule_rounded,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PlaceholderPage(title: 'Exam Schedules'),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildExamCard(
            context,
            'Results',
            Icons.assessment_rounded,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PlaceholderPage(title: 'Results'),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Show dialog or navigate to create exam page
          _showCreateExamDialog(context);
        },
        backgroundColor: const Color(0xFF283593),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Create Exam',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildExamCard(
    BuildContext context,
    String title,
    IconData icon, {
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF283593).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFF283593)),
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

  void _showCreateExamDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Exam'),
        content: const Text('Exam creation functionality will be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Add exam creation logic here
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF283593),
            ),
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}

// Placeholder page for demonstration
// Replace these with your actual pages
class PlaceholderPage extends StatelessWidget {
  final String title;

  const PlaceholderPage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFF283593),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Text(
          '$title Page\n(To be implemented)',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}