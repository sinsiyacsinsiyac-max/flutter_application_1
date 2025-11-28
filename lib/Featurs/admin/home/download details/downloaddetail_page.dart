import 'package:flutter/material.dart';

class DownloadsManagementPage extends StatelessWidget {
  const DownloadsManagementPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Downloads Management',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color.fromARGB(255, 38, 159, 234),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildDownloadCard(
            context,
            'Notes',
            Icons.notes_rounded,
            'Access all your course notes',
            () => _navigateToCategory(context, 'Notes'),
          ),
          const SizedBox(height: 12),
          _buildDownloadCard(
            context,
            'Previous Question Papers',
            Icons.quiz_rounded,
            'Past exam papers and solutions',
            () => _navigateToCategory(context, 'Previous Question Papers'),
          ),
          const SizedBox(height: 12),
          _buildDownloadCard(
            context,
            'Syllabus',
            Icons.book_rounded,
            'Course syllabus and curriculum',
            () => _navigateToCategory(context, 'Syllabus'),
          ),
          const SizedBox(height: 12),
          _buildDownloadCard(
            context,
            'Study Materials',
            Icons.folder_rounded,
            'Additional learning resources',
            () => _navigateToCategory(context, 'Study Materials'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showUploadDialog(context),
        backgroundColor: const Color.fromARGB(255, 73, 148, 233),
        icon: const Icon(Icons.upload_file, color: Colors.white),
        label: const Text(
          'Upload File',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildDownloadCard(
    BuildContext context,
    String title,
    IconData icon,
    String subtitle,
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
            color: const Color.fromARGB(255, 92, 158, 235).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color.fromARGB(255, 93, 163, 243)),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            subtitle,
            style: TextStyle(
              fontSize: 13,
              color: const Color.fromARGB(255, 95, 187, 240),
            ),
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  void _navigateToCategory(BuildContext context, String category) {
    // Navigate to the specific category page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryFilesPage(category: category),
      ),
    );
  }

  void _showUploadDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Upload File'),
          content: const Text('Select file upload method:'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Add file picker logic here
              },
              child: const Text('Choose File'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}

// Category Files Page (placeholder for navigation)
class CategoryFilesPage extends StatelessWidget {
  final String category;

  const CategoryFilesPage({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(category),
        backgroundColor: const Color.fromARGB(255, 92, 165, 248),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Text(
          '$category files will appear here',
          style: TextStyle(fontSize: 16, color: const Color.fromARGB(255, 94, 195, 249)),
        ),
      ),
    );
  }
}