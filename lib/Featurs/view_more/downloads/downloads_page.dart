import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NotesDownloadPage extends StatelessWidget {
  const NotesDownloadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes Download"),
        backgroundColor: Colors.blue[900],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('study_materials')
            .where('type', isEqualTo: 'notes')
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
              'No Notes Available',
              Icons.note_rounded,
              'Check back later for uploaded notes',
            );
          }

          final notes = snapshot.data!.docs;

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: notes.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final note = notes[index].data() as Map<String, dynamic>;
              final noteId = notes[index].id;

              return _buildNoteCard(context, note, noteId);
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

  Widget _buildNoteCard(BuildContext context, Map<String, dynamic> note, String noteId) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.green.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.note_rounded,
            color: Colors.green.shade700,
            size: 28,
          ),
        ),
        title: Text(
          note['title'] ?? 'Untitled Notes',
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
              '${note['subject'] ?? ''} • ${note['course'] ?? ''}',
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '${note['semester'] ?? ''} • ${note['year'] ?? ''}',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
            if (note['fileSize'] != null) ...[
              const SizedBox(height: 2),
              Text(
                '${note['fileSize']} • ${note['downloadCount'] ?? 0} downloads',
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
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.download_rounded,
            color: Colors.blue.shade700,
            size: 20,
          ),
        ),
        onTap: () => _downloadNotes(context, note, noteId),
      ),
    );
  }

  void _downloadNotes(BuildContext context, Map<String, dynamic> note, String noteId) async {
    final fileUrl = note['fileUrl'];
    
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
          .doc(noteId)
          .update({
            'downloadCount': FieldValue.increment(1),
            'updatedAt': FieldValue.serverTimestamp(),
          });

      // Launch the PDF URL
      if (await canLaunchUrl(Uri.parse(fileUrl))) {
        await launchUrl(Uri.parse(fileUrl));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Opening ${note['title']}...'),
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
