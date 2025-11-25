import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Main Course List Screen
class TeacherCoursePanel extends StatefulWidget {
  const TeacherCoursePanel({Key? key}) : super(key: key);

  @override
  State<TeacherCoursePanel> createState() => _TeacherCoursePanelState();
}

class _TeacherCoursePanelState extends State<TeacherCoursePanel> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('My Courses'),
        backgroundColor: Colors.blue.shade700,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('courses')
            .where(
              'teacherId',
              //  isEqualTo: _auth.currentUser?.uid
            )
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return _buildEmptyState();
          }

          return _buildCoursesList(snapshot.data!.docs);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddCourseScreen()),
          );
        },
        backgroundColor: Colors.blue.shade700,
        icon: const Icon(Icons.add),
        label: const Text('Add Course'),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.class_, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No Courses Yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the button below to create your first course',
            style: TextStyle(color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildCoursesList(List<QueryDocumentSnapshot> courses) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final courseDoc = courses[index];
        final course = courseDoc.data() as Map<String, dynamic>;
        final courseId = courseDoc.id;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: CircleAvatar(
              backgroundColor: Colors.blue.shade100,
              child: Icon(Icons.class_, color: Colors.blue.shade700),
            ),
            title: Text(
              course['name'] ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(course['code'] ?? ''),
                const SizedBox(height: 4),
                Text(
                  '${course['department']} • ${course['credits']} credits',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                if (course['hasFees'] == true) ...[
                  const SizedBox(height: 2),
                  Text(
                    'Fees: ₹${course['totalFees']?.toStringAsFixed(0) ?? '0'}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CourseDetailScreen(courseId: courseId, course: course),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

// Add Course Screen
class AddCourseScreen extends StatefulWidget {
  final String? courseId;
  final Map<String, dynamic>? existingCourse;

  const AddCourseScreen({Key? key, this.courseId, this.existingCourse})
    : super(key: key);

  @override
  State<AddCourseScreen> createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends State<AddCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _courseNameController = TextEditingController();
  final _courseCodeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _creditsController = TextEditingController();
  final _maxStudentsController = TextEditingController();
  final _totalFeesController = TextEditingController();
  final _semesterFeesController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _selectedDepartment = 'Computer Science';
  String _selectedSemester = '4 sem';
  bool _isLoading = false;
  bool _showFeesOption = false;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.courseId != null;

    // If editing, populate fields with existing data
    if (_isEditing && widget.existingCourse != null) {
      final course = widget.existingCourse!;
      _courseNameController.text = course['name'] ?? '';
      _courseCodeController.text = course['code'] ?? '';
      _descriptionController.text = course['description'] ?? '';
      _selectedDepartment = course['department'] ?? 'Computer Science';
      _selectedSemester = course['semester'] ?? '4 sem';
      _creditsController.text = course['credits']?.toString() ?? '';
      _maxStudentsController.text = course['maxStudents']?.toString() ?? '';
      _showFeesOption = course['hasFees'] == true;

      if (_showFeesOption) {
        _totalFeesController.text = course['totalFees']?.toString() ?? '';
        _semesterFeesController.text = course['semesterFees']?.toString() ?? '';
      }
    }
  }

  @override
  void dispose() {
    _courseNameController.dispose();
    _courseCodeController.dispose();
    _descriptionController.dispose();
    _creditsController.dispose();
    _maxStudentsController.dispose();
    _totalFeesController.dispose();
    _semesterFeesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Course' : 'Add New Course'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextFormField(
                  controller: _courseNameController,
                  decoration: const InputDecoration(
                    labelText: 'Course Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.class_),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _courseCodeController,
                  decoration: const InputDecoration(
                    labelText: 'Course Code',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.code),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.description),
                  ),
                  maxLines: 3,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedDepartment,
                  decoration: const InputDecoration(
                    labelText: 'Department',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.business),
                  ),
                  items:
                      const [
                        'Computer Science',
                        'Mechanical Engineering',
                        'Electrical Engineering',
                        'Mathematics',
                        'Physics',
                        'commerce',
                        'english',
                      ].map((dept) {
                        return DropdownMenuItem(value: dept, child: Text(dept));
                      }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedDepartment = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedSemester,
                  decoration: const InputDecoration(
                    labelText: 'Semester',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  items: const ['2 sem', '4 sem', '6 sem'].map((sem) {
                    return DropdownMenuItem(value: sem, child: Text(sem));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedSemester = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _creditsController,
                        decoration: const InputDecoration(
                          labelText: 'Credits',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.credit_score),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                            value?.isEmpty ?? true ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _maxStudentsController,
                        decoration: const InputDecoration(
                          labelText: 'Max Students',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.people),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                            value?.isEmpty ?? true ? 'Required' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Show Fees Option Toggle
                Card(
                  color: Colors.blue.shade50,
                  child: SwitchListTile(
                    title: const Text(
                      'Add Fee Structure',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: const Text(
                      'Enable to add course fees information',
                    ),
                    value: _showFeesOption,
                    onChanged: (value) {
                      setState(() {
                        _showFeesOption = value;
                        if (!value) {
                          // Clear fee fields when disabled
                          _totalFeesController.clear();
                          _semesterFeesController.clear();
                        }
                      });
                    },
                    activeColor: Colors.blue.shade700,
                  ),
                ),

                // Conditional Fee Fields
                if (_showFeesOption) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _totalFeesController,
                          decoration: const InputDecoration(
                            labelText: 'Total Fees',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.attach_money),
                            prefixText: '₹ ',
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) =>
                              _showFeesOption && (value?.isEmpty ?? true)
                              ? 'Required'
                              : null,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _semesterFeesController,
                          decoration: const InputDecoration(
                            labelText: 'Per Semester',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.payments),
                            prefixText: '₹ ',
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) =>
                              _showFeesOption && (value?.isEmpty ?? true)
                              ? 'Required'
                              : null,
                        ),
                      ),
                    ],
                  ),
                ],

                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _submitCourse,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    padding: const EdgeInsets.all(16),
                  ),
                  child: Text(
                    _isEditing ? 'Update Course' : 'Create Course',
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black26,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  Future<void> _submitCourse() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final user = _auth.currentUser;
        if (user == null) {
          throw Exception('User not authenticated');
        }

        final courseData = {
          'name': _courseNameController.text.trim(),
          'code': _courseCodeController.text.trim().toUpperCase(),
          'description': _descriptionController.text.trim(),
          'department': _selectedDepartment,
          'semester': _selectedSemester,
          'credits': int.parse(_creditsController.text),
          'maxStudents': int.parse(_maxStudentsController.text),
          'hasFees': _showFeesOption,
          'teacherId': user.uid,
          'teacherName': user.displayName ?? user.email ?? 'Unknown',
          'updatedAt': FieldValue.serverTimestamp(),
        };

        // Add fee data only if fees option is enabled
        if (_showFeesOption) {
          courseData['totalFees'] = double.parse(_totalFeesController.text);
          courseData['semesterFees'] = double.parse(
            _semesterFeesController.text,
          );
        } else {
          // Remove fee data if fees are disabled
          courseData['totalFees'] = FieldValue.delete();
          courseData['semesterFees'] = FieldValue.delete();
        }

        if (_isEditing) {
          // Update existing course
          await _firestore
              .collection('courses')
              .doc(widget.courseId)
              .update(courseData);

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Course updated successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          }
        } else {
          // Create new course
          courseData['enrolledStudents'] = 0;
          courseData['createdAt'] = FieldValue.serverTimestamp();

          await _firestore.collection('courses').add(courseData);

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Course created successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Error ${_isEditing ? 'updating' : 'creating'} course: $e',
              ),
              backgroundColor: Colors.red,
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

// Course Detail Screen
class CourseDetailScreen extends StatelessWidget {
  final String courseId;
  final Map<String, dynamic> course;

  const CourseDetailScreen({
    Key? key,
    required this.courseId,
    required this.course,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(course['code'] ?? ''),
        backgroundColor: Colors.blue.shade700,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'delete') {
                _showDeleteDialog(context);
              } else if (value == 'edit') {
                _editCourse(context);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit, size: 20),
                    SizedBox(width: 8),
                    Text('Edit Course'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, size: 20, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Delete Course', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Container(
              width: double.infinity,
              color: Colors.blue.shade700,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course['name'] ?? '',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    course['code'] ?? '',
                    style: const TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ],
              ),
            ),

            // Details Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Course Information',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(
                    Icons.business,
                    'Department',
                    course['department'] ?? '',
                  ),
                  _buildInfoRow(
                    Icons.calendar_today,
                    'Semester',
                    course['semester'] ?? '',
                  ),
                  _buildInfoRow(
                    Icons.credit_score,
                    'Credits',
                    '${course['credits']} hours',
                  ),
                  _buildInfoRow(
                    Icons.people,
                    'Max Students',
                    '${course['maxStudents']}',
                  ),

                  if (course['hasFees'] == true) ...[
                    _buildInfoRow(
                      Icons.attach_money,
                      'Total Fees',
                      '₹${course['totalFees']?.toStringAsFixed(2) ?? '0.00'}',
                    ),
                    _buildInfoRow(
                      Icons.payments,
                      'Semester Fees',
                      '₹${course['semesterFees']?.toStringAsFixed(2) ?? '0.00'}',
                    ),
                  ],

                  const SizedBox(height: 24),
                  const Text(
                    'Description',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    course['description'] ?? '',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Fee Structure - Only show if course has fees
                  if (course['hasFees'] == true) ...[
                    const Text(
                      'Fee Structure',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      color: Colors.green.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.account_balance_wallet,
                                      color: Colors.green.shade700,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      'Total Course Fees',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  '₹${course['totalFees']?.toStringAsFixed(2) ?? '0.00'}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.green.shade700,
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.payment,
                                      color: Colors.green.shade700,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      'Per Semester',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  '₹${course['semesterFees']?.toStringAsFixed(2) ?? '0.00'}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.green.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  const Text(
                    'Enrollment Status',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Current Enrollment'),
                              Text(
                                '${course['enrolledStudents'] ?? 0}/${course['maxStudents']}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value:
                                (course['enrolledStudents'] ?? 0) /
                                (course['maxStudents'] ?? 1).toDouble(),
                            backgroundColor: Colors.grey.shade300,
                            color: Colors.blue,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
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
          Icon(icon, size: 20, color: Colors.blue.shade700),
          const SizedBox(width: 12),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w500)),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }

  void _editCourse(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AddCourseScreen(courseId: courseId, existingCourse: course),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Course'),
        content: Text(
          'Are you sure you want to delete "${course['name']}"? This action cannot be undone.',
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
                    .collection('courses')
                    .doc(courseId)
                    .delete();

                if (context.mounted) {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Return to list

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Course deleted successfully'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error deleting course: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
