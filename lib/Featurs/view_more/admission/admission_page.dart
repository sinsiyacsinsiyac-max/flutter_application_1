import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdmissionPage extends StatefulWidget {
  final String collegeId; // Pass college ID when navigating

  const AdmissionPage({Key? key, required this.collegeId}) : super(key: key);

  @override
  State<AdmissionPage> createState() => _AdmissionPageState();
}

class _AdmissionPageState extends State<AdmissionPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic> _collegeData = {};
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
      // Get all colleges and take the first one
      final querySnapshot = await _firestore
          .collection('colleges')
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        setState(() {
          _collegeData = doc.data();
          _collegeId = doc.id;
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

  List<dynamic> get _admissionDocuments {
    return _collegeData['admissionRequirements']?['documents'] ??
        [
          {
            'title': 'Birth Certificate',
            'description': 'Original and photocopy',
          },
          {
            'title': 'Transfer Certificate',
            'description': 'From previous school',
          },
          {'title': 'Mark Sheets', 'description': 'Last 2 years'},
          {'title': 'Address Proof', 'description': 'Utility bill or Aadhar'},
          {'title': 'Photographs', 'description': '4 passport size photos'},
        ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${_collegeData['name'] ?? 'College'} Admissions'),
        backgroundColor: const Color(0xFF0D47A1),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Header Section
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xFF0D47A1),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Icon(
                          Icons.school_rounded,
                          size: 60,
                          color: Colors.white.withOpacity(0.9),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Welcome to ${_collegeData['name'] ?? 'College'} Admissions',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Required Documents Section
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFF0D47A1,
                                    ).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.description_rounded,
                                    color: Color(0xFF0D47A1),
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'Required Documents',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0D47A1),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            ..._admissionDocuments
                                .map(
                                  (doc) => _buildDocumentItem(
                                    doc['title'],
                                    doc['description'],
                                  ),
                                )
                                .toList(),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Contact Information Section
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFF0D47A1,
                                    ).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.contact_phone_rounded,
                                    color: Color(0xFF0D47A1),
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'Contact Information',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0D47A1),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            _buildContactItem(
                              Icons.phone_rounded,
                              'Office Phone',
                              _collegeData['phone'] ?? 'Not available',
                            ),
                            const SizedBox(height: 12),
                            _buildContactItem(
                              Icons.email_rounded,
                              'Email',
                              _collegeData['email'] ?? 'Not available',
                            ),
                            const SizedBox(height: 12),
                            _buildContactItem(
                              Icons.access_time_rounded,
                              'Office Hours',
                              _collegeData['officeHours'] ?? 'Not specified',
                            ),
                            const SizedBox(height: 12),
                            _buildContactItem(
                              Icons.location_on_rounded,
                              'Address',
                              _collegeData['address'] ?? 'Not available',
                            ),
                            if (_collegeData['website'] != null) ...[
                              const SizedBox(height: 12),
                              _buildContactItem(
                                Icons.language_rounded,
                                'Website',
                                _collegeData['website']!,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  Widget _buildDocumentItem(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 4),
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFF0D47A1),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF0D47A1), size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
