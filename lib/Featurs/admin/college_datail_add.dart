import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CollegeDetailsPage extends StatefulWidget {
  const CollegeDetailsPage({Key? key}) : super(key: key);

  @override
  State<CollegeDetailsPage> createState() => _CollegeDetailsPageState();
}

class _CollegeDetailsPageState extends State<CollegeDetailsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _officeHoursController = TextEditingController();

  // Admission requirements controllers
  final TextEditingController _birthCertificateController =
      TextEditingController();
  final TextEditingController _transferCertificateController =
      TextEditingController();
  final TextEditingController _markSheetsController = TextEditingController();
  final TextEditingController _addressProofController = TextEditingController();
  final TextEditingController _photographsController = TextEditingController();

  bool _isEditing = false;
  bool _isLoading = false;
  String? _collegeId;

  @override
  void initState() {
    super.initState();
    _loadCollegeData();
  }

  Future<void> _loadCollegeData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final collegeSnapshot = await _firestore
          .collection('colleges')
          .where('adminId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      if (collegeSnapshot.docs.isNotEmpty) {
        final collegeData = collegeSnapshot.docs.first.data();
        _collegeId = collegeSnapshot.docs.first.id;

        setState(() {
          _nameController.text = collegeData['name'] ?? '';
          _emailController.text = collegeData['email'] ?? '';
          _phoneController.text = collegeData['phone'] ?? '';
          _addressController.text = collegeData['address'] ?? '';
          _websiteController.text = collegeData['website'] ?? '';
          _officeHoursController.text = collegeData['officeHours'] ?? '';

          // Load admission requirements
          final admissionReqs = collegeData['admissionRequirements'] ?? {};
          final documents = admissionReqs['documents'] ?? [];

          if (documents.isNotEmpty) {
            for (var doc in documents) {
              switch (doc['title']) {
                case 'Birth Certificate':
                  _birthCertificateController.text = doc['description'] ?? '';
                  break;
                case 'Transfer Certificate':
                  _transferCertificateController.text =
                      doc['description'] ?? '';
                  break;
                case 'Mark Sheets':
                  _markSheetsController.text = doc['description'] ?? '';
                  break;
                case 'Address Proof':
                  _addressProofController.text = doc['description'] ?? '';
                  break;
                case 'Photographs':
                  _photographsController.text = doc['description'] ?? '';
                  break;
              }
            }
          } else {
            // Set default values if no data exists
            _birthCertificateController.text = 'Original and photocopy';
            _transferCertificateController.text = 'From previous school';
            _markSheetsController.text = 'Last 2 years';
            _addressProofController.text = 'Utility bill or Aadhar';
            _photographsController.text = '4 passport size photos';
          }
        });
      }
    } catch (e) {
      print('Error loading college data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveCollegeData() async {
    if (_nameController.text.isEmpty || _emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('College name and email are required'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final collegeData = {
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'address': _addressController.text.trim(),
        'website': _websiteController.text.trim(),
        'officeHours': _officeHoursController.text.trim(),
        'adminId': FirebaseAuth.instance.currentUser!.uid,
        'admissionRequirements': {
          'documents': [
            {
              'title': 'Birth Certificate',
              'description': _birthCertificateController.text.trim(),
            },
            {
              'title': 'Transfer Certificate',
              'description': _transferCertificateController.text.trim(),
            },
            {
              'title': 'Mark Sheets',
              'description': _markSheetsController.text.trim(),
            },
            {
              'title': 'Address Proof',
              'description': _addressProofController.text.trim(),
            },
            {
              'title': 'Photographs',
              'description': _photographsController.text.trim(),
            },
          ],
        },
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (_collegeId == null) {
        // Create new college document
        await _firestore.collection('colleges').add({
          ...collegeData,
          'createdAt': FieldValue.serverTimestamp(),
        });
      } else {
        // Update existing college document
        await _firestore
            .collection('colleges')
            .doc(_collegeId!)
            .update(collegeData);
      }

      setState(() {
        _isEditing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('College details saved successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving college data: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF1A237E).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFF1A237E)),
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        subtitle: Text(
          value.isEmpty ? 'Not set' : value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: value.isEmpty ? Colors.grey : Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    String hint,
    TextEditingController controller,
    TextInputType inputType,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: inputType,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF1A237E)),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildAdmissionRequirementField(
    String documentTitle,
    String hint,
    TextEditingController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          documentTitle,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF1A237E)),
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'College Details',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A237E),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.school_rounded,
                          size: 48,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _isEditing
                              ? 'Edit College Details'
                              : 'College Information',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _isEditing
                              ? 'Update your college contact information'
                              : 'View and manage college contact details',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  if (_isEditing) ...[
                    // Edit Form - Basic Information
                    const Text(
                      'Basic Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A237E),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      'College Name *',
                      'Enter college name',
                      _nameController,
                      TextInputType.text,
                    ),
                    _buildTextField(
                      'Email Address *',
                      'Enter college email',
                      _emailController,
                      TextInputType.emailAddress,
                    ),
                    _buildTextField(
                      'Phone Number',
                      'Enter contact number',
                      _phoneController,
                      TextInputType.phone,
                    ),
                    _buildTextField(
                      'Address',
                      'Enter college address',
                      _addressController,
                      TextInputType.multiline,
                    ),
                    _buildTextField(
                      'Website',
                      'Enter website URL',
                      _websiteController,
                      TextInputType.url,
                    ),
                    _buildTextField(
                      'Office Hours',
                      'e.g., Mon-Fri: 9:00 AM - 4:00 PM',
                      _officeHoursController,
                      TextInputType.text,
                    ),

                    // Admission Requirements Section
                    const SizedBox(height: 24),
                    const Text(
                      'Admission Requirements',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A237E),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildAdmissionRequirementField(
                      'Birth Certificate',
                      'e.g., Original and photocopy',
                      _birthCertificateController,
                    ),
                    _buildAdmissionRequirementField(
                      'Transfer Certificate',
                      'e.g., From previous school',
                      _transferCertificateController,
                    ),
                    _buildAdmissionRequirementField(
                      'Mark Sheets',
                      'e.g., Last 2 years',
                      _markSheetsController,
                    ),
                    _buildAdmissionRequirementField(
                      'Address Proof',
                      'e.g., Utility bill or Aadhar',
                      _addressProofController,
                    ),
                    _buildAdmissionRequirementField(
                      'Photographs',
                      'e.g., 4 passport size photos',
                      _photographsController,
                    ),

                    // Action Buttons
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                _isEditing = false;
                              });
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              side: const BorderSide(color: Colors.grey),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _saveCollegeData,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1A237E),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text(
                              'Save Changes',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    // Display Mode - Basic Information
                    _buildInfoCard(
                      'College Name',
                      _nameController.text,
                      Icons.school_rounded,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoCard(
                      'Email Address',
                      _emailController.text,
                      Icons.email_rounded,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoCard(
                      'Phone Number',
                      _phoneController.text,
                      Icons.phone_rounded,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoCard(
                      'Address',
                      _addressController.text,
                      Icons.location_on_rounded,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoCard(
                      'Website',
                      _websiteController.text,
                      Icons.language_rounded,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoCard(
                      'Office Hours',
                      _officeHoursController.text,
                      Icons.access_time_rounded,
                    ),

                    // Display Mode - Admission Requirements
                    const SizedBox(height: 24),
                    const Text(
                      'Admission Requirements',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A237E),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoCard(
                      'Birth Certificate',
                      _birthCertificateController.text,
                      Icons.description_rounded,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoCard(
                      'Transfer Certificate',
                      _transferCertificateController.text,
                      Icons.description_rounded,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoCard(
                      'Mark Sheets',
                      _markSheetsController.text,
                      Icons.description_rounded,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoCard(
                      'Address Proof',
                      _addressProofController.text,
                      Icons.description_rounded,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoCard(
                      'Photographs',
                      _photographsController.text,
                      Icons.description_rounded,
                    ),

                    // Empty State
                    if (_nameController.text.isEmpty &&
                        _emailController.text.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          children: [
                            Icon(
                              Icons.school_outlined,
                              size: 64,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'No College Details Added',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Click the edit button to add your college information',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _websiteController.dispose();
    _officeHoursController.dispose();
    _birthCertificateController.dispose();
    _transferCertificateController.dispose();
    _markSheetsController.dispose();
    _addressProofController.dispose();
    _photographsController.dispose();
    super.dispose();
  }
}
