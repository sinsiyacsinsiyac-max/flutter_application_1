import 'package:flutter/material.dart';

class AddCourseDetailsPage extends StatefulWidget {
   AddCourseDetailsPage({Key? key,this.courcename}) : super(key: key);
String? courcename;
  @override
  State<AddCourseDetailsPage> createState() => _AddCourseDetailsPageState();
}

class _AddCourseDetailsPageState extends State<AddCourseDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final _courseNameController = TextEditingController();
  final _overviewController = TextEditingController();
  final _durationController = TextEditingController();
  final _modeController = TextEditingController();
  final _mediumController = TextEditingController();
  final _minMarksController = TextEditingController();
  final _ageLimitController = TextEditingController();
  final _annualFeeController = TextEditingController();
  final _oneTimeFeeController = TextEditingController();
  
  // Lists for dynamic fields
  final List<TextEditingController> _eligibilityControllers = [TextEditingController()];
  final List<TextEditingController> _careerControllers = [TextEditingController()];
  final List<Map<String, dynamic>> _semesters = [
    {'semester': TextEditingController(text: 'Semester 1 & 2'), 'subjects': <TextEditingController>[TextEditingController()]}
  ];
  
  bool _scholarshipAvailable = true;
  bool _entranceRequired = false;

  @override
  void dispose() {
    _courseNameController.dispose();
    _overviewController.dispose();
    _durationController.dispose();
    _modeController.dispose();
    _mediumController.dispose();
    _minMarksController.dispose();
    _ageLimitController.dispose();
    _annualFeeController.dispose();
    _oneTimeFeeController.dispose();
    
    for (var controller in _eligibilityControllers) {
      controller.dispose();
    }
    for (var controller in _careerControllers) {
      controller.dispose();
    }
    for (var semester in _semesters) {
      (semester['semester'] as TextEditingController).dispose();
      for (var controller in (semester['subjects'] as List<TextEditingController>)) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title:  Text(
          'Add New corse detail ${widget.courcename??''}',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildBasicInfoCard(),
            const SizedBox(height: 16),
            _buildDurationCard(),
            const SizedBox(height: 16),
            _buildEligibilityCard(),
            const SizedBox(height: 16),
            _buildSyllabusCard(),
            const SizedBox(height: 16),
            _buildCareerCard(),
            const SizedBox(height: 16),
            _buildFeeStructureCard(),
            const SizedBox(height: 24),
            _buildSubmitButton(),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoCard() {
    return Card(
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A237E).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.info_rounded,
                    color: Color(0xFF1A237E),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Basic Information',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A237E),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _courseNameController,
              decoration: InputDecoration(
                labelText: 'Course Name *',
                hintText: 'e.g., Bachelor of Computer Applications',
                prefixIcon: const Icon(Icons.school_rounded),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter course name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _overviewController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Course Overview *',
                hintText: 'Brief description of the course...',
                prefixIcon: const Icon(Icons.description_rounded),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter course overview';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDurationCard() {
    return Card(
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D47A1).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.schedule_rounded,
                    color: Color(0xFF0D47A1),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Duration & Structure',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D47A1),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _durationController,
              decoration: InputDecoration(
                labelText: 'Duration *',
                hintText: 'e.g., 3 Years (6 Semesters)',
                prefixIcon: const Icon(Icons.calendar_today_rounded),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter duration';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _modeController,
              decoration: InputDecoration(
                labelText: 'Mode *',
                hintText: 'e.g., Full-time / Part-time',
                prefixIcon: const Icon(Icons.class_rounded),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter mode';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _mediumController,
              decoration: InputDecoration(
                labelText: 'Medium *',
                hintText: 'e.g., English',
                prefixIcon: const Icon(Icons.language_rounded),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter medium';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEligibilityCard() {
    return Card(
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF283593).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    color: Color(0xFF283593),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Eligibility Criteria',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF283593),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline, color: Color(0xFF283593)),
                  onPressed: () {
                    setState(() {
                      _eligibilityControllers.add(TextEditingController());
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _minMarksController,
              decoration: InputDecoration(
                labelText: 'Minimum Marks Required *',
                hintText: 'e.g., 50%',
                prefixIcon: const Icon(Icons.percent_rounded),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter minimum marks';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _ageLimitController,
              decoration: InputDecoration(
                labelText: 'Age Limit *',
                hintText: 'e.g., 17-25 years',
                prefixIcon: const Icon(Icons.cake_rounded),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter age limit';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Entrance Exam Required'),
              value: _entranceRequired,
              onChanged: (value) {
                setState(() {
                  _entranceRequired = value;
                });
              },
              activeColor: const Color(0xFF283593),
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 16),
            Text(
              'Other Eligibility Requirements:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 12),
            ..._eligibilityControllers.asMap().entries.map((entry) {
              int index = entry.key;
              TextEditingController controller = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: controller,
                        decoration: InputDecoration(
                          hintText: 'e.g., 10+2 or equivalent qualification',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        ),
                      ),
                    ),
                    if (_eligibilityControllers.length > 1)
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            _eligibilityControllers[index].dispose();
                            _eligibilityControllers.removeAt(index);
                          });
                        },
                      ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSyllabusCard() {
    return Card(
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1565C0).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.menu_book_rounded,
                    color: Color(0xFF1565C0),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Course Syllabus',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1565C0),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline, color: Color(0xFF1565C0)),
                  onPressed: () {
                    setState(() {
                      _semesters.add({
                        'semester': TextEditingController(text: 'Semester ${_semesters.length * 2 + 1} & ${_semesters.length * 2 + 2}'),
                        'subjects': <TextEditingController>[TextEditingController()]
                      });
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            ..._semesters.asMap().entries.map((entry) {
              int semIndex = entry.key;
              Map<String, dynamic> semester = entry.value;
              TextEditingController semesterController = semester['semester'] as TextEditingController;
              List<TextEditingController> subjectControllers = semester['subjects'] as List<TextEditingController>;
              
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: semesterController,
                            decoration: InputDecoration(
                              labelText: 'Semester Name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            ),
                          ),
                        ),
                        if (_semesters.length > 1)
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                (semester['semester'] as TextEditingController).dispose();
                                for (var controller in subjectControllers) {
                                  controller.dispose();
                                }
                                _semesters.removeAt(semIndex);
                              });
                            },
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Text(
                          'Subjects:',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                        const Spacer(),
                        TextButton.icon(
                          onPressed: () {
                            setState(() {
                              subjectControllers.add(TextEditingController());
                            });
                          },
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('Add Subject'),
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFF1565C0),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...subjectControllers.asMap().entries.map((subEntry) {
                      int subIndex = subEntry.key;
                      TextEditingController controller = subEntry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: controller,
                                decoration: InputDecoration(
                                  hintText: 'e.g., Computer Fundamentals',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                ),
                              ),
                            ),
                            if (subjectControllers.length > 1)
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline, color: Colors.red, size: 20),
                                onPressed: () {
                                  setState(() {
                                    controller.dispose();
                                    subjectControllers.removeAt(subIndex);
                                  });
                                },
                              ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildCareerCard() {
    return Card(
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00695C).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.work_rounded,
                    color: Color(0xFF00695C),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Career Opportunities',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00695C),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline, color: Color(0xFF00695C)),
                  onPressed: () {
                    setState(() {
                      _careerControllers.add(TextEditingController());
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            ..._careerControllers.asMap().entries.map((entry) {
              int index = entry.key;
              TextEditingController controller = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: controller,
                        decoration: InputDecoration(
                          hintText: 'e.g., Software Developer',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        ),
                      ),
                    ),
                    if (_careerControllers.length > 1)
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            _careerControllers[index].dispose();
                            _careerControllers.removeAt(index);
                          });
                        },
                      ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildFeeStructureCard() {
    return Card(
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE65100).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.payments_rounded,
                    color: Color(0xFFE65100),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Fee Structure',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE65100),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _annualFeeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Annual Fee *',
                hintText: 'e.g., ₹45,000 - ₹60,000',
                prefixIcon: const Icon(Icons.currency_rupee),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter annual fee';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _oneTimeFeeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'One-time Fee *',
                hintText: 'e.g., ₹5,000',
                prefixIcon: const Icon(Icons.account_balance_rounded),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter one-time fee';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Scholarships Available'),
              value: _scholarshipAvailable,
              onChanged: (value) {
                setState(() {
                  _scholarshipAvailable = value;
                });
              },
              activeColor: Colors.green[700],
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A237E), Color(0xFF283593)],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A237E).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Add Course',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Collect all data
      final courseData = {
        'courseName': _courseNameController.text,
        'overview': _overviewController.text,
        'duration': _durationController.text,
        'mode': _modeController.text,
        'medium': _mediumController.text,
        'minMarks': _minMarksController.text,
        'ageLimit': _ageLimitController.text,
        'entranceRequired': _entranceRequired,
        'eligibility': _eligibilityControllers.map((c) => c.text).where((t) => t.isNotEmpty).toList(),
        'semesters': _semesters.map((s) => {
          'semester': (s['semester'] as TextEditingController).text,
          'subjects': (s['subjects'] as List<TextEditingController>)
              .map((c) => c.text)
              .where((t) => t.isNotEmpty)
              .toList(),
        }).toList(),
        'careers': _careerControllers.map((c) => c.text).where((t) => t.isNotEmpty).toList(),
        'annualFee': _annualFeeController.text,
        'oneTimeFee': _oneTimeFeeController.text,
        'scholarshipAvailable': _scholarshipAvailable,
      };

      // TODO: Save the data to your backend/database
      print('Course Data: $courseData');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Course added successfully!'),
          backgroundColor: Color(0xFF00695C),
          behavior: SnackBarBehavior.floating,
        ),
      );

      // Navigate back or to course list
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}