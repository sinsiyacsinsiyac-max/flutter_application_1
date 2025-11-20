import 'package:flutter/material.dart';

class AdmissionManagementPage extends StatelessWidget {
  const AdmissionManagementPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Admission Management',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF0D47A1),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildAdminCard(
            context,
            'Documents Required',
            'Manage required documents',
            Icons.description_rounded,
            () {
              // Navigate to Documents Required page
              // Navigator.push(context, MaterialPageRoute(builder: (context) => DocumentsRequiredPage()));
              _showComingSoon(context, 'Documents Required');
            },
          ),
          const SizedBox(height: 12),
          _buildAdminCard(
            context,
            'Contact Information',
            'Update admission contacts',
            Icons.phone_rounded,
            () {
              // Navigate to Contact Information page
              // Navigator.push(context, MaterialPageRoute(builder: (context) => ContactInformationPage()));
              _showComingSoon(context, 'Contact Information');
            },
          ),
          const SizedBox(height: 12),
          _buildAdminCard(
            context,
            'Application Status',
            'Track admission applications',
            Icons.fact_check_rounded,
            () {
              // Navigate to Application Status page
              // Navigator.push(context, MaterialPageRoute(builder: (context) => ApplicationStatusPage()));
              _showComingSoon(context, 'Application Status');
            },
          ),
          const SizedBox(height: 12),
          _buildAdminCard(
            context,
            'Admission Criteria',
            'Set admission requirements',
            Icons.rule_rounded,
            () {
              // Navigate to Admission Criteria page
              // Navigator.push(context, MaterialPageRoute(builder: (context) => AdmissionCriteriaPage()));
              _showComingSoon(context, 'Admission Criteria');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAdminCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF0D47A1).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFF0D47A1)),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }

  // Helper method to show placeholder dialog
  void _showComingSoon(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(feature),
        content: const Text('This feature is coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}