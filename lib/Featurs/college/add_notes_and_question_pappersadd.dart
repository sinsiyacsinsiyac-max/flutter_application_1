import 'dart:developer';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/Featurs/college/cloudnary_uplaod.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:developer' as developer;

// Main Notes & Papers Panel
class NotesPapersPanel extends StatefulWidget {
  const NotesPapersPanel({Key? key}) : super(key: key);

  @override
  State<NotesPapersPanel> createState() => _NotesPapersPanelState();
}

class _NotesPapersPanelState extends State<NotesPapersPanel> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int _selectedTab = 0;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Study Materials'),
        backgroundColor: Colors.indigo.shade700,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Tab Bar
          Container(
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  children: [
                    _buildTab(0, 'Notes'),
                    _buildTab(1, 'Question Papers'),
                  ],
                ),
                // Search Bar
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search by title or subject...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value.toLowerCase();
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Content based on tab
          Expanded(
            child: _selectedTab == 0 ? _buildNotesList() : _buildPapersList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddMaterialScreen(
                materialType: _selectedTab == 0 ? 'notes' : 'papers',
              ),
            ),
          );
        },
        backgroundColor: Colors.indigo.shade700,
        icon: const Icon(Icons.add),
        label: Text(_selectedTab == 0 ? 'Add Notes' : 'Add Papers'),
      ),
    );
  }

  Widget _buildTab(int index, String title) {
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedTab = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: _selectedTab == index ? Colors.indigo.shade50 : Colors.white,
            border: Border(
              bottom: BorderSide(
                color: _selectedTab == index
                    ? Colors.indigo.shade700
                    : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: _selectedTab == index
                  ? Colors.indigo.shade700
                  : Colors.grey.shade600,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotesList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('study_materials')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _buildErrorState(snapshot.error.toString());
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyState('No Study Materials', Icons.note_add);
        }

        // Filter notes client-side to avoid index issues
        final notes = snapshot.data!.docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return data['type'] == 'notes';
        }).toList();

        if (notes.isEmpty) {
          return _buildEmptyState('No Notes Added', Icons.note_add);
        }

        return _buildMaterialsList(notes, 'notes');
      },
    );
  }

  Widget _buildPapersList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('study_materials')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _buildErrorState(snapshot.error.toString());
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyState('No Study Materials', Icons.assignment);
        }

        // Filter papers client-side to avoid index issues
        final papers = snapshot.data!.docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return data['type'] == 'papers';
        }).toList();

        if (papers.isEmpty) {
          return _buildEmptyState('No Papers Added', Icons.assignment);
        }

        return _buildMaterialsList(papers, 'papers');
      },
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              'Error Loading Data',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error.contains('index')
                  ? 'Please wait while the database updates...'
                  : 'Error: $error',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            if (error.contains('index')) const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the + button to add new materials',
            style: TextStyle(color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildMaterialsList(
    List<QueryDocumentSnapshot> materials,
    String type,
  ) {
    // Filter materials based on search query
    final filteredMaterials = _searchQuery.isEmpty
        ? materials
        : materials.where((material) {
            final data = material.data() as Map<String, dynamic>;
            final title = data['title']?.toString().toLowerCase() ?? '';
            final subject = data['subject']?.toString().toLowerCase() ?? '';
            final course = data['course']?.toString().toLowerCase() ?? '';
            return title.contains(_searchQuery) ||
                subject.contains(_searchQuery) ||
                course.contains(_searchQuery);
          }).toList();

    if (filteredMaterials.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 60, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            const Text(
              'No materials found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search query',
              style: TextStyle(color: Colors.grey.shade500),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredMaterials.length,
      itemBuilder: (context, index) {
        final materialDoc = filteredMaterials[index];
        final material = materialDoc.data() as Map<String, dynamic>;
        final materialId = materialDoc.id;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: _getMaterialColor(type),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                type == 'notes' ? Icons.note_rounded : Icons.assignment_rounded,
                color: Colors.white,
                size: 30,
              ),
            ),
            title: Text(
              material['title'] ?? 'Untitled',
              style: const TextStyle(fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  material['subject'] ?? 'No subject',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(Icons.class_, size: 14, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(
                      '${material['course'] ?? 'No course'} - ${material['semester'] ?? 'No semester'}',
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(Icons.person, size: 14, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text('By ${material['uploadedByName'] ?? 'Unknown'}'),
                  ],
                ),
                if (material['fileSize'] != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    '${material['fileSize']} • ${material['downloadCount'] ?? 0} downloads',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ],
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MaterialDetailScreen(
                    materialId: materialId,
                    material: material,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Color _getMaterialColor(String type) {
    return type == 'notes' ? Colors.green.shade700 : Colors.orange.shade700;
  }
}

// Add Study Material Screen
class AddMaterialScreen extends StatefulWidget {
  final String materialType;

  const AddMaterialScreen({Key? key, required this.materialType})
    : super(key: key);

  @override
  State<AddMaterialScreen> createState() => _AddMaterialScreenState();
}

class _AddMaterialScreenState extends State<AddMaterialScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _subjectController = TextEditingController();
  final _descriptionController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _selectedCourse = 'BCA';
  String _selectedSemester = 'Semester 1';
  String _selectedYear = '2024';
  bool _isLoading = false;
  File? _selectedFile;
  String? _uploadedFileUrl;
  String? _fileSize;

  // Course options
  final List<String> courses = [
    'BCA',
    'BCom',
    'BBA',
    'BComCA',
    'MA',
    'BA',
    'BSC Physics',
    'MSC Physics',
    'MA English',
  ];

  // Semester options
  final List<String> semesters = [
    'Semester 1',
    'Semester 2',
    'Semester 3',
    'Semester 4',
    'Semester 5',
    'Semester 6',
    'Semester 7',
    'Semester 8',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        File file = File(result.files.single.path!);
        int fileSizeInBytes = await file.length();
        double fileSizeInMB = fileSizeInBytes / (1024 * 1024);

        setState(() {
          _selectedFile = file;
          _fileSize = '${fileSizeInMB.toStringAsFixed(2)} MB';
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking file: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _getFileTypeIcon() {
    return widget.materialType == 'notes' ? 'Notes' : 'Question Papers';
  }

  Color _getFileTypeColor() {
    return widget.materialType == 'notes'
        ? Colors.green.shade700
        : Colors.orange.shade700;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add ${_getFileTypeIcon()}'),
        backgroundColor: _getFileTypeColor(),
      ),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // File Upload Section
                GestureDetector(
                  onTap: _pickFile,
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _selectedFile != null
                            ? _getFileTypeColor()
                            : Colors.grey.shade400,
                        width: 2,
                      ),
                    ),
                    child: _selectedFile != null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.picture_as_pdf,
                                size: 60,
                                color: Colors.red.shade700,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _selectedFile!.path.split('/').last,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (_fileSize != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  _fileSize!,
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                              const SizedBox(height: 4),
                              Text(
                                'Tap to change file',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.upload_file,
                                size: 60,
                                color: Colors.grey.shade600,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Tap to upload PDF file',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Only PDF files are allowed',
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 20),

                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: '${_getFileTypeIcon()} Title',
                    border: const OutlineInputBorder(),
                    prefixIcon: Icon(Icons.title, color: _getFileTypeColor()),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Required' : null,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _subjectController,
                  decoration: InputDecoration(
                    labelText: 'Subject Name',
                    border: const OutlineInputBorder(),
                    prefixIcon: Icon(Icons.subject, color: _getFileTypeColor()),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Required' : null,
                ),
                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  value: _selectedCourse,
                  decoration: InputDecoration(
                    labelText: 'Course',
                    border: const OutlineInputBorder(),
                    prefixIcon: Icon(Icons.school, color: _getFileTypeColor()),
                  ),
                  items: courses.map((course) {
                    return DropdownMenuItem(value: course, child: Text(course));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCourse = value!;
                    });
                  },
                  validator: (value) => value == null ? 'Required' : null,
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedSemester,
                        decoration: InputDecoration(
                          labelText: 'Semester',
                          border: const OutlineInputBorder(),
                          prefixIcon: Icon(
                            Icons.calendar_today,
                            color: _getFileTypeColor(),
                          ),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 8,
                          ),
                        ),
                        items: semesters.map((semester) {
                          return DropdownMenuItem(
                            value: semester,
                            child: Text(
                              semester,
                              style: const TextStyle(fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedSemester = value!;
                          });
                        },
                        validator: (value) => value == null ? 'Required' : null,
                        isExpanded: true,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: _getFileTypeColor(),
                        ),
                        dropdownColor: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedYear,
                        decoration: InputDecoration(
                          labelText: 'Year',
                          border: const OutlineInputBorder(),
                          prefixIcon: Icon(
                            Icons.calendar_month,
                            color: _getFileTypeColor(),
                          ),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 8,
                          ),
                        ),
                        items: ['2022', '2023', '2024', '2025'].map((year) {
                          return DropdownMenuItem(
                            value: year,
                            child: Text(
                              year,
                              style: const TextStyle(fontSize: 14),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedYear = value!;
                          });
                        },
                        validator: (value) => value == null ? 'Required' : null,
                        isExpanded: true,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: _getFileTypeColor(),
                        ),
                        dropdownColor: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description (Optional)',
                    border: const OutlineInputBorder(),
                    prefixIcon: Icon(
                      Icons.description,
                      color: _getFileTypeColor(),
                    ),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 30),

                ElevatedButton(
                  onPressed: _isLoading ? null : _submitMaterial,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _getFileTypeColor(),
                    padding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        )
                      : Text(
                          'Upload ${_getFileTypeIcon()}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitMaterial() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a PDF file'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        final user = _auth.currentUser;
        if (user == null) {
          throw Exception('User not authenticated');
        }

        // Upload PDF to Cloudinary
        _uploadedFileUrl = await CloudneryUploader().uploadFile(
          XFile(_selectedFile!.path),
        );

        final newMaterial = {
          'title': _titleController.text.trim(),
          'subject': _subjectController.text.trim(),
          'description': _descriptionController.text.trim(),
          'course': _selectedCourse,
          'semester': _selectedSemester,
          'year': _selectedYear,
          'type': widget.materialType,
          'fileUrl': _uploadedFileUrl,
          'fileSize': _fileSize,
          'fileName': _selectedFile!.path.split('/').last,
          'uploadedBy': user.uid,
          'uploadedByName': user.displayName ?? user.email ?? 'Unknown',
          'downloadCount': 0,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        };

        await _firestore.collection('study_materials').add(newMaterial);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${_getFileTypeIcon()} uploaded successfully!'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        print('Error uploading material: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error uploading file: $e'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }
}

// Material Detail Screen with PDF Preview
class MaterialDetailScreen extends StatefulWidget {
  final String materialId;
  final Map<String, dynamic> material;

  const MaterialDetailScreen({
    Key? key,
    required this.materialId,
    required this.material,
  }) : super(key: key);

  @override
  State<MaterialDetailScreen> createState() => _MaterialDetailScreenState();
}

class _MaterialDetailScreenState extends State<MaterialDetailScreen> {
  bool _isDownloading = false;
  double _downloadProgress = 0.0;
  String? _localFilePath;

  @override
  Widget build(BuildContext context) {
    final isNotes = widget.material['type'] == 'notes';
    final color = isNotes ? Colors.green.shade700 : Colors.orange.shade700;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Material Details'),
        backgroundColor: color,
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
              if (value == 'delete') {
                _showDeleteDialog(context);
              } else if (value == 'share') {
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
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Delete', style: TextStyle(color: Colors.red)),
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
                color: color.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircularProgressIndicator(
                            value: _downloadProgress,
                            color: color,
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
                        color: color,
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
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: color),
                      ),
                      child: Text(
                        isNotes ? 'Notes' : 'Question Paper',
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.material['title'] ?? 'Untitled',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.material['subject'] ?? 'No subject',
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
                      widget.material['course'] ?? 'Not specified',
                    ),
                    _buildInfoRow(
                      Icons.calendar_today,
                      'Semester',
                      widget.material['semester'] ?? 'Not specified',
                    ),
                    _buildInfoRow(
                      Icons.date_range,
                      'Year',
                      widget.material['year'] ?? 'Not specified',
                    ),
                    _buildInfoRow(
                      Icons.storage,
                      'File Size',
                      widget.material['fileSize'] ?? 'Unknown',
                    ),
                    _buildInfoRow(
                      Icons.download,
                      'Downloads',
                      '${widget.material['downloadCount'] ?? 0}',
                    ),
                    _buildInfoRow(
                      Icons.person,
                      'Uploaded By',
                      widget.material['uploadedByName'] ?? 'Unknown',
                    ),
                    _buildInfoRow(
                      Icons.access_time,
                      'Upload Date',
                      _formatDate(widget.material['createdAt']),
                    ),
                  ],
                ),
              ),
            ),

            if (widget.material['description'] != null &&
                widget.material['description'].isNotEmpty) ...[
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
                        widget.material['description']!,
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
                      backgroundColor: color,
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
                      foregroundColor: color,
                      side: BorderSide(color: color, width: 2),
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

  String _formatDate(dynamic timestamp) {
    if (timestamp == null) return 'Unknown';

    try {
      if (timestamp is Timestamp) {
        final date = timestamp.toDate();
        return '${date.day}/${date.month}/${date.year}';
      }
      return 'Unknown';
    } catch (e) {
      return 'Unknown';
    }
  }

  Future<void> _downloadFile(BuildContext context) async {
    final fileUrl = widget.material['fileUrl'];

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

      final fileName = _getFileName(
        widget.material['fileName'] ?? 'download.pdf',
      );
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
      final fileName = _getFileName(
        widget.material['fileName'] ?? 'download.pdf',
      );
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
          .doc(widget.materialId)
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

    // Check if file exists
    final file = File(_localFilePath!);
    if (!file.existsSync()) {
      _showSnackBar(
        context,
        'File not found. Please download again.',
        Colors.red,
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PDFViewerScreen(
          filePath: _localFilePath!,
          title: widget.material['title'] ?? 'PDF Viewer',
        ),
      ),
    );
  }

  Future<void> _openInBrowser(BuildContext context) async {
    final fileUrl = widget.material['fileUrl'];

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
    final fileUrl = widget.material['fileUrl'];
    final title = widget.material['title'] ?? 'Study Material';

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

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Material'),
        content: Text(
          'Are you sure you want to delete "${widget.material['title']}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await FirebaseFirestore.instance
                    .collection('study_materials')
                    .doc(widget.materialId)
                    .delete();

                if (context.mounted) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  _showSnackBar(
                    context,
                    'Material deleted successfully',
                    Colors.green,
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  Navigator.pop(context);
                  _showSnackBar(context, 'Error deleting: $e', Colors.red);
                }
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
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

// PDF Viewer Screen
class PDFViewerScreen extends StatefulWidget {
  final String filePath;
  final String title;

  const PDFViewerScreen({Key? key, required this.filePath, required this.title})
    : super(key: key);

  @override
  State<PDFViewerScreen> createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {
  int _currentPage = 0;
  int _totalPages = 0;
  bool _isReady = false;
  String? _errorMessage;
  PDFViewController? _pdfViewController;

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
        backgroundColor: Colors.indigo.shade700,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _sharePDF(context),
          ),
        ],
      ),
      body: _buildPDFView(),
      floatingActionButton: _buildNavigationButtons(),
    );
  }

  Widget _buildPDFView() {
    if (_errorMessage != null) {
      return _buildErrorView();
    }

    return Stack(
      children: [
        PDFView(
          filePath: widget.filePath,
          enableSwipe: true,
          swipeHorizontal: false,
          autoSpacing: true,
          pageFling: true,
          pageSnap: true,
          defaultPage: 0,
          fitPolicy: FitPolicy.BOTH,
          preventLinkNavigation: false,
          onRender: (pages) {
            setState(() {
              _totalPages = pages ?? 0;
              _isReady = true;
            });
          },
          onError: (error) {
            setState(() {
              _errorMessage = error.toString();
              _isReady = true;
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
            });
          },
          onViewCreated: (PDFViewController controller) {
            _pdfViewController = controller;
          },
        ),
        if (!_isReady) const Center(child: CircularProgressIndicator()),
      ],
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              'Error Loading PDF',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _errorMessage = null;
                  _isReady = false;
                });
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget? _buildNavigationButtons() {
    if (!_isReady || _totalPages <= 1) return null;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton.small(
          heroTag: 'prev',
          onPressed: _currentPage > 0 ? _goToPreviousPage : null,
          child: const Icon(Icons.arrow_back),
        ),
        const SizedBox(width: 8),
        FloatingActionButton.small(
          heroTag: 'next',
          onPressed: _currentPage < _totalPages - 1 ? _goToNextPage : null,
          child: const Icon(Icons.arrow_forward),
        ),
      ],
    );
  }

  void _goToPreviousPage() {
    final previousPage = _currentPage - 1;
    _pdfViewController?.setPage(previousPage);
  }

  void _goToNextPage() {
    final nextPage = _currentPage + 1;
    _pdfViewController?.setPage(nextPage);
  }

  Future<void> _sharePDF(BuildContext context) async {
    try {
      final file = XFile(widget.filePath);
      await Share.shareXFiles([file], text: 'Sharing ${widget.title}');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error sharing file: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _pdfViewController?.dispose();
    super.dispose();
  }
}
