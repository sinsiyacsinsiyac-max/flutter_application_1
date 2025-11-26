import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/Featurs/college/add_notes_and_question_pappersadd.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:developer' as developer;

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
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
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

          // Client-side sorting
          final notes = snapshot.data!.docs;
          notes.sort((a, b) {
            final aData = a.data() as Map<String, dynamic>;
            final bData = b.data() as Map<String, dynamic>;
            final aTime = aData['createdAt'] as Timestamp?;
            final bTime = bData['createdAt'] as Timestamp?;

            if (aTime == null && bTime == null) return 0;
            if (aTime == null) return 1;
            if (bTime == null) return -1;

            return bTime.compareTo(aTime); // Descending order
          });

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: notes.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final noteDoc = notes[index];
              final note = noteDoc.data() as Map<String, dynamic>;
              final noteId = noteDoc.id;

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

  Widget _buildNoteCard(
    BuildContext context,
    Map<String, dynamic> note,
    String noteId,
  ) {
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
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              '${note['subject'] ?? ''} • ${note['course'] ?? ''}',
              style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
            ),
            const SizedBox(height: 2),
            Text(
              '${note['semester'] ?? ''} • ${note['year'] ?? ''}',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
            if (note['fileSize'] != null) ...[
              const SizedBox(height: 2),
              Text(
                '${note['fileSize']} • ${note['downloadCount'] ?? 0} downloads',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
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
            Icons.arrow_forward_ios,
            color: Colors.blue.shade700,
            size: 18,
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  NoteDetailScreen(noteId: noteId, note: note),
            ),
          );
        },
      ),
    );
  }
}

// Note Detail Screen
class NoteDetailScreen extends StatefulWidget {
  final String noteId;
  final Map<String, dynamic> note;

  const NoteDetailScreen({Key? key, required this.noteId, required this.note})
    : super(key: key);

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  bool _isDownloading = false;
  double _downloadProgress = 0.0;
  String? _localFilePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Note Details'),
        backgroundColor: Colors.green.shade700,
        actions: [
          if (_localFilePath != null)
            IconButton(
              icon: const Icon(Icons.preview),
              tooltip: 'View PDF',
              onPressed: () => _viewPDF(context),
            ),
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: 'Download',
            onPressed: _isDownloading ? null : () => _downloadFile(context),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'share') {
                _shareMaterial(context);
              } else if (value == 'open_browser') {
                _openInBrowser(context);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'open_browser',
                child: Row(
                  children: [
                    Icon(Icons.open_in_browser),
                    SizedBox(width: 8),
                    Text('Open in Browser'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'share',
                child: Row(
                  children: [
                    Icon(Icons.share),
                    SizedBox(width: 8),
                    Text('Share'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Download Progress Indicator
            if (_isDownloading)
              Card(
                color: Colors.green.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircularProgressIndicator(
                            value: _downloadProgress,
                            color: Colors.green.shade700,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Downloading...',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${(_downloadProgress * 100).toStringAsFixed(0)}%',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: _downloadProgress,
                        backgroundColor: Colors.grey.shade300,
                        color: Colors.green.shade700,
                      ),
                    ],
                  ),
                ),
              ),

            if (_isDownloading) const SizedBox(height: 16),

            // Header Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.green.shade700),
                      ),
                      child: Text(
                        'Notes',
                        style: TextStyle(
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.note['title'] ?? 'Untitled',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.note['subject'] ?? 'No subject',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Details Section
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Material Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow(
                      Icons.school,
                      'Course',
                      widget.note['course'] ?? 'Not specified',
                    ),
                    _buildInfoRow(
                      Icons.calendar_today,
                      'Semester',
                      widget.note['semester'] ?? 'Not specified',
                    ),
                    _buildInfoRow(
                      Icons.date_range,
                      'Year',
                      widget.note['year'] ?? 'Not specified',
                    ),
                    _buildInfoRow(
                      Icons.storage,
                      'File Size',
                      widget.note['fileSize'] ?? 'Unknown',
                    ),
                    _buildInfoRow(
                      Icons.download,
                      'Downloads',
                      '${widget.note['downloadCount'] ?? 0}',
                    ),
                    _buildInfoRow(
                      Icons.person,
                      'Uploaded By',
                      widget.note['uploadedByName'] ?? 'Unknown',
                    ),
                  ],
                ),
              ),
            ),

            if (widget.note['description'] != null &&
                widget.note['description'].isNotEmpty) ...[
              const SizedBox(height: 20),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.note['description']!,
                        style: const TextStyle(fontSize: 14, height: 1.5),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 30),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isDownloading
                        ? null
                        : () => _downloadFile(context),
                    icon: const Icon(Icons.download_rounded),
                    label: const Text(
                      'Download',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _openInBrowser(context),
                    icon: const Icon(Icons.open_in_browser),
                    label: const Text(
                      'Open',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.green.shade700,
                      side: BorderSide(color: Colors.green.shade700, width: 2),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _downloadFile(BuildContext context) async {
    final fileUrl = widget.note['fileUrl'];

    if (fileUrl == null) {
      _showSnackBar(context, 'File not available for download', Colors.red);
      return;
    }

    try {
      setState(() {
        _isDownloading = true;
        _downloadProgress = 0.0;
      });

      // Request storage permission
      if (Platform.isAndroid) {
        // For all Android versions, request storage permission
        final status = await Permission.storage.request();
        if (!status.isGranted) {
          // If storage permission denied, try with manage external storage
          final manageStatus = await Permission.manageExternalStorage.request();
          if (!manageStatus.isGranted) {
            _showSnackBar(context, 'Storage permission denied', Colors.red);
            setState(() => _isDownloading = false);
            return;
          }
        }
      }

      await _downloadToDownloadsFolder(fileUrl);
    } catch (e) {
      setState(() => _isDownloading = false);
      _showSnackBar(context, 'Error downloading: $e', Colors.red);
    }
  }

  Future<void> _downloadToDownloadsFolder(String fileUrl) async {
    try {
      Directory? directory;
      if (Platform.isAndroid) {
        // Try to get downloads directory
        if (await Permission.manageExternalStorage.isGranted) {
          directory = Directory('/storage/emulated/0/Download');
          if (!await directory.exists()) {
            directory = await getExternalStorageDirectory();
          }
        } else {
          directory = await getExternalStorageDirectory();
        }
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      if (directory == null) {
        throw Exception('Could not access storage directory');
      }

      final fileName = _getFileName(widget.note['fileName'] ?? 'download.pdf');
      final filePath = '${directory.path}/$fileName';

      await _performDownload(fileUrl, filePath);
    } catch (e) {
      // Fallback to app directory
      await _downloadToAppDirectory(fileUrl);
    }
  }

  Future<void> _downloadToAppDirectory(String fileUrl) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final fileName = _getFileName(widget.note['fileName'] ?? 'download.pdf');
      final filePath = '${directory.path}/$fileName';

      await _performDownload(fileUrl, filePath);

      if (mounted) {
        _showSnackBar(context, 'Downloaded to app directory', Colors.green);
      }
    } catch (e) {
      throw Exception('Failed to download to app directory: $e');
    }
  }

  Future<void> _performDownload(String fileUrl, String filePath) async {
    final request = http.Request('GET', Uri.parse(fileUrl));
    final response = await http.Client().send(request);

    if (response.statusCode == 200) {
      final totalBytes = response.contentLength ?? 0;
      int receivedBytes = 0;

      final file = File(filePath);
      final sink = file.openWrite();

      await for (var chunk in response.stream) {
        sink.add(chunk);
        receivedBytes += chunk.length;

        if (totalBytes > 0) {
          setState(() {
            _downloadProgress = receivedBytes / totalBytes;
          });
        }
      }

      await sink.close();

      setState(() {
        _localFilePath = filePath;
        _isDownloading = false;
      });

      // Update download count
      await FirebaseFirestore.instance
          .collection('study_materials')
          .doc(widget.noteId)
          .update({
            'downloadCount': FieldValue.increment(1),
            'updatedAt': FieldValue.serverTimestamp(),
          });

      if (mounted) {
        _showViewDialog(context);
      }
    } else {
      throw Exception('Failed to download: ${response.statusCode}');
    }
  }

  String _getFileName(String originalName) {
    // Clean file name and ensure .pdf extension
    String cleanName = originalName.replaceAll(RegExp(r'[^\w\s.-]'), '');
    if (!cleanName.toLowerCase().endsWith('.pdf')) {
      cleanName += '.pdf';
    }
    return cleanName;
  }

  void _showViewDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Download Complete'),
        content: const Text('Would you like to view the PDF now?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Later'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _viewPDF(context);
            },
            child: const Text('View Now'),
          ),
        ],
      ),
    );
  }

  void _viewPDF(BuildContext context) {
    if (_localFilePath == null) {
      _showSnackBar(context, 'Please download the file first', Colors.orange);
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PDFViewerScreen(
          filePath: _localFilePath!,
          title: widget.note['title'] ?? 'PDF Viewer',
        ),
      ),
    );
  }

  Future<void> _openInBrowser(BuildContext context) async {
    final fileUrl = widget.note['fileUrl'];

    if (fileUrl == null) {
      _showSnackBar(context, 'File URL not available', Colors.red);
      return;
    }

    // Always use Google Docs viewer for maximum compatibility
    final String googleDocsUrl =
        "https://docs.google.com/gview?embedded=true&url=${Uri.encodeComponent(fileUrl)}";

    try {
      final uri = Uri.parse(googleDocsUrl);

      if (await canLaunchUrl(uri)) {
        final launched = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );

        if (!launched) {
          throw Exception('Launch returned false');
        }
      } else {
        throw Exception('Cannot launch URL');
      }
    } catch (e) {
      developer.log('Browser open failed: $e');

      // Final fallback - show dialog with multiple options
      await showDialog(
        context: context,
        builder: (context) => SimpleDialog(
          title: const Text('Cannot Open PDF'),
          children: [
            ListTile(
              leading: const Icon(Icons.download),
              title: const Text('Download File'),
              onTap: () {
                Navigator.pop(context);
                _downloadFile(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.content_copy),
              title: const Text('Copy URL'),
              onTap: () {
                Navigator.pop(context);
                Clipboard.setData(ClipboardData(text: fileUrl));
                _showSnackBar(context, 'URL copied to clipboard', Colors.green);
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel),
              title: const Text('Cancel'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _shareMaterial(BuildContext context) async {
    final fileUrl = widget.note['fileUrl'];
    final title = widget.note['title'] ?? 'Study Material';

    if (fileUrl == null) {
      _showSnackBar(
        context,
        'Cannot share: File URL not available',
        Colors.red,
      );
      return;
    }

    try {
      await Share.share('$title\n\nDownload: $fileUrl', subject: title);
    } catch (e) {
      _showSnackBar(context, 'Error sharing: $e', Colors.red);
    }
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
