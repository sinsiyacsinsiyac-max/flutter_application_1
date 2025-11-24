import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PreviousQuestionPapersPage extends StatelessWidget {
  const PreviousQuestionPapersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Previous Question Papers"),
        backgroundColor: Colors.purple,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('study_materials')
            .where('type', isEqualTo: 'papers')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return _buildEmptyState(
              'No Question Papers Available',
              Icons.quiz_rounded,
              'Check back later for uploaded question papers',
            );
          }

          final papers = snapshot.data!.docs;

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: papers.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final paper = papers[index].data() as Map<String, dynamic>;
              final paperId = papers[index].id;

              return _buildPaperCard(context, paper, paperId);
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(String title, IconData icon, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(color: Colors.grey.shade500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPaperCard(BuildContext context, Map<String, dynamic> paper, String paperId) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.orange.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.quiz_rounded,
            color: Colors.orange.shade700,
            size: 28,
          ),
        ),
        title: Text(
          paper['title'] ?? 'Untitled Paper',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              '${paper['subject'] ?? ''} • ${paper['course'] ?? ''}',
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '${paper['semester'] ?? ''} • ${paper['year'] ?? ''}',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
            if (paper['fileSize'] != null) ...[
              const SizedBox(height: 2),
              Text(
                '${paper['fileSize']} • ${paper['downloadCount'] ?? 0} downloads',
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 11,
                ),
              ),
            ],
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.purple.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.download_rounded,
            color: Colors.purple.shade700,
            size: 20,
          ),
        ),
        onTap: () => _downloadPaper(context, paper, paperId),
      ),
    );
  }

  void _downloadPaper(BuildContext context, Map<String, dynamic> paper, String paperId) async {
    final fileUrl = paper['fileUrl'];
    
    if (fileUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('File not available for download'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // Update download count
      await FirebaseFirestore.instance
          .collection('study_materials')
          .doc(paperId)
          .update({
            'downloadCount': FieldValue.increment(1),
            'updatedAt': FieldValue.serverTimestamp(),
          });

      // Launch the PDF URL
      if (await canLaunchUrl(Uri.parse(fileUrl))) {
        await launchUrl(Uri.parse(fileUrl));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Opening ${paper['title']}...'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        throw 'Could not launch $fileUrl';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error downloading file: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}