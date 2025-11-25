import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:image_picker/image_picker.dart';

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

          // Sort client-side by createdAt
          papers.sort((a, b) {
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
            itemCount: papers.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final paperDoc = papers[index];
              final paper = paperDoc.data() as Map<String, dynamic>;
              final paperId = paperDoc.id;

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
            Icons.arrow_forward_ios,
            color: Colors.purple.shade700,
            size: 18,
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaperDetailScreen(
                paperId: paperId,
                paper: paper,
              ),
            ),
          );
        },
      ),
    );
  }
}

// Paper Detail Screen
class PaperDetailScreen extends StatefulWidget {
  final String paperId;
  final Map<String, dynamic> paper;

  const PaperDetailScreen({
    Key? key,
    required this.paperId,
    required this.paper,
  }) : super(key: key);

  @override
  State<PaperDetailScreen> createState() => _PaperDetailScreenState();
}

class _PaperDetailScreenState extends State<PaperDetailScreen> {
  bool _isDownloading = false;
  double _downloadProgress = 0.0;
  String? _localFilePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Question Paper Details'),
        backgroundColor: Colors.orange.shade700,
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
                color: Colors.orange.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircularProgressIndicator(
                            value: _downloadProgress,
                            color: Colors.orange.shade700,
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
                        color: Colors.orange.shade700,
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
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.orange.shade700),
                      ),
                      child: Text(
                        'Question Paper',
                        style: TextStyle(
                          color: Colors.orange.shade700,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.paper['title'] ?? 'Untitled',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.paper['subject'] ?? 'No subject',
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
                      'Paper Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow(Icons.school, 'Course', widget.paper['course'] ?? 'Not specified'),
                    _buildInfoRow(Icons.calendar_today, 'Semester', widget.paper['semester'] ?? 'Not specified'),
                    _buildInfoRow(Icons.date_range, 'Year', widget.paper['year'] ?? 'Not specified'),
                    _buildInfoRow(Icons.storage, 'File Size', widget.paper['fileSize'] ?? 'Unknown'),
                    _buildInfoRow(Icons.download, 'Downloads', '${widget.paper['downloadCount'] ?? 0}'),
                    _buildInfoRow(Icons.person, 'Uploaded By', widget.paper['uploadedByName'] ?? 'Unknown'),
                  ],
                ),
              ),
            ),

            if (widget.paper['description'] != null && widget.paper['description'].isNotEmpty) ...[
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
                        widget.paper['description']!,
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.5,
                        ),
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
                    onPressed: _isDownloading ? null : () => _downloadFile(context),
                    icon: const Icon(Icons.download_rounded),
                    label: const Text(
                      'Download',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade700,
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
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.orange.shade700,
                      side: BorderSide(color: Colors.orange.shade700, width: 2),
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
              style: const TextStyle(
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _downloadFile(BuildContext context) async {
    final fileUrl = widget.paper['fileUrl'];
    
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
        final status = await Permission.storage.request();
        if (!status.isGranted) {
          _showSnackBar(context, 'Storage permission denied', Colors.red);
          setState(() => _isDownloading = false);
          return;
        }
      }

      // Get download directory
      Directory? directory;
      if (Platform.isAndroid) {
        directory = await getExternalStorageDirectory();
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      final fileName = widget.paper['fileName'] ?? 'paper.pdf';
      final filePath = '${directory!.path}/$fileName';

      // Download file with progress
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
            .doc(widget.paperId)
            .update({
              'downloadCount': FieldValue.increment(1),
              'updatedAt': FieldValue.serverTimestamp(),
            });

        if (mounted) {
          _showSnackBar(context, 'Downloaded successfully!', Colors.green);
          _showViewDialog(context);
        }
      } else {
        throw Exception('Failed to download: ${response.statusCode}');
      }
    } catch (e) {
      setState(() => _isDownloading = false);
      _showSnackBar(context, 'Error downloading: $e', Colors.red);
    }
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
          title: widget.paper['title'] ?? 'PDF Viewer',
        ),
      ),
    );
  }

  Future<void> _openInBrowser(BuildContext context) async {
    final fileUrl = widget.paper['fileUrl'];
    
    if (fileUrl == null) {
      _showSnackBar(context, 'File URL not available', Colors.red);
      return;
    }

    try {
      final uri = Uri.parse(fileUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw Exception('Could not launch URL');
      }
    } catch (e) {
      _showSnackBar(context, 'Error opening file: $e', Colors.red);
    }
  }

  Future<void> _shareMaterial(BuildContext context) async {
    final fileUrl = widget.paper['fileUrl'];
    final title = widget.paper['title'] ?? 'Study Material';
    
    if (fileUrl == null) {
      _showSnackBar(context, 'Cannot share: File URL not available', Colors.red);
      return;
    }

    try {
      await Share.share(
        '$title\n\nDownload: $fileUrl',
        subject: title,
      );
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

// PDF Viewer Screen (reused from notes)
class PDFViewerScreen extends StatefulWidget {
  final String filePath;
  final String title;

  const PDFViewerScreen({
    Key? key,
    required this.filePath,
    required this.title,
  }) : super(key: key);

  @override
  State<PDFViewerScreen> createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {
  int _currentPage = 0;
  int _totalPages = 0;
  bool _isReady = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: const TextStyle(fontSize: 16),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (_isReady && _totalPages > 0)
              Text(
                'Page ${_currentPage + 1} of $_totalPages',
                style: const TextStyle(fontSize: 12),
              ),
          ],
        ),
        backgroundColor: Colors.orange.shade700,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () async {
              await Share.shareXFiles([XFile(widget.filePath)]);
            },
          ),
        ],
      ),
      body: _errorMessage != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 60, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      'Error Loading PDF',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            )
          : Stack(
              children: [
                PDFView(
                  filePath: widget.filePath,
                  enableSwipe: true,
                  swipeHorizontal: false,
                  autoSpacing: true,
                  pageFling: true,
                  pageSnap: true,
                  onRender: (pages) {
                    setState(() {
                      _totalPages = pages ?? 0;
                      _isReady = true;
                    });
                  },
                  onError: (error) {
                    setState(() {
                      _errorMessage = error.toString();
                    });
                  },
                  onPageError: (page, error) {
                    setState(() {
                      _errorMessage = 'Error on page $page: $error';
                    });
                  },
                  onPageChanged: (page, total) {
                    setState(() {
                      _currentPage = page ?? 0;
                      _totalPages = total ?? 0;
                    });
                  },
                ),
                if (!_isReady)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
    );
  }
}