import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class AddDownloadScreen extends StatefulWidget {
  final String category; // Notes, Previous Question Papers, etc.

  const AddDownloadScreen({Key? key, required this.category}) : super(key: key);

  @override
  State<AddDownloadScreen> createState() => _AddDownloadScreenState();
}

class _AddDownloadScreenState extends State<AddDownloadScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _subjectController = TextEditingController();
  
  String? _selectedSemester;
  String? _selectedFileType;
  String? _selectedFileName;
  bool _isUploading = false;

  final List<String> _semesters = ['S1', 'S2', 'S3', 'S4', 'S5', 'S6', 'S7', 'S8'];
  final List<String> _fileTypes = ['PDF', 'DOC', 'DOCX', 'PPT', 'PPTX', 'ZIP'];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _subjectController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'ppt', 'pptx', 'zip'],
      );

      if (result != null) {
        setState(() {
          _selectedFileName = result.files.single.name;
          // Auto-detect file type from extension
          String extension = result.files.single.extension?.toUpperCase() ?? '';
          if (_fileTypes.contains(extension)) {
            _selectedFileType = extension;
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking file: $e')),
      );
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedFileName == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a file to upload')),
        );
        return;
      }

      setState(() {
        _isUploading = true;
      });

      // Simulate upload delay
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isUploading = false;
      });

      // Show success message and navigate back
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('File uploaded successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(
          'Add ${widget.category}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF073D7A),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Title Field
            _buildSectionTitle('Basic Information'),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _titleController,
              label: 'Title',
              hint: 'Enter title (e.g., Data Structures Notes)',
              icon: Icons.title,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Description Field
            _buildTextField(
              controller: _descriptionController,
              label: 'Description',
              hint: 'Enter description (optional)',
              icon: Icons.description,
              maxLines: 3,
            ),
            const SizedBox(height: 16),

            // Subject Field
            _buildTextField(
              controller: _subjectController,
              label: 'Subject',
              hint: 'Enter subject name',
              icon: Icons.subject,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter subject name';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Academic Information
            _buildSectionTitle('Academic Information'),
            const SizedBox(height: 8),
            _buildDropdownField(
              label: 'Semester',
              value: _selectedSemester,
              items: _semesters,
              icon: Icons.calendar_today,
              onChanged: (value) {
                setState(() {
                  _selectedSemester = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a semester';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // File Upload Section
            _buildSectionTitle('File Upload'),
            const SizedBox(height: 8),
            _buildFilePickerCard(),
            const SizedBox(height: 16),

            if (_selectedFileName != null) ...[
              _buildDropdownField(
                label: 'File Type',
                value: _selectedFileType,
                items: _fileTypes,
                icon: Icons.file_present,
                onChanged: (value) {
                  setState(() {
                    _selectedFileType = value;
                  });
                },
              ),
              const SizedBox(height: 24),
            ],

            // Submit Button
            SizedBox(
              height: 54,
              child: ElevatedButton(
                onPressed: _isUploading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF073D7A),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: _isUploading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : const Text(
                        'Upload File',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Color(0xFF073D7A),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            prefixIcon: Icon(icon, color: const Color(0xFF073D7A)),
            border: InputBorder.none,
            labelStyle: const TextStyle(
              color: Color(0xFF073D7A),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required IconData icon,
    required void Function(String?) onChanged,
    String? Function(String?)? validator,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(icon, color: const Color(0xFF073D7A)),
            border: InputBorder.none,
            labelStyle: const TextStyle(
              color: Color(0xFF073D7A),
              fontWeight: FontWeight.w500,
            ),
          ),
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
          validator: validator,
        ),
      ),
    );
  }

  Widget _buildFilePickerCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: _pickFile,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF073D7A).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _selectedFileName != null
                      ? Icons.check_circle
                      : Icons.cloud_upload,
                  color: const Color(0xFF073D7A),
                  size: 48,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _selectedFileName ?? 'Tap to select file',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _selectedFileName != null
                      ? const Color(0xFF073D7A)
                      : Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Supported formats: PDF, DOC, DOCX, PPT, PPTX, ZIP',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}