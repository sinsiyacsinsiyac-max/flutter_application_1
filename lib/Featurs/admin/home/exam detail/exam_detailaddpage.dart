import 'package:flutter/material.dart';

class AddExamScreen extends StatefulWidget {
  const AddExamScreen({Key? key}) : super(key: key);

  @override
  State<AddExamScreen> createState() => _AddExamScreenState();
}

class _AddExamScreenState extends State<AddExamScreen> {
  final _formKey = GlobalKey<FormState>();
  final _examNameController = TextEditingController();
  final _examCodeController = TextEditingController();
  final _totalMarksController = TextEditingController();
  final _passingMarksController = TextEditingController();
  final _durationController = TextEditingController();
  final _roomNumberController = TextEditingController();
  final _instructionsController = TextEditingController();

  String _selectedExamType = 'Internal';
  String _selectedSemester = 'Semester 1';
  String _selectedDepartment = 'Computer Science';
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  final List<String> _examTypes = ['Internal', 'External', 'Final', 'Midterm', 'Quiz'];
  final List<String> _semesters = ['Semester 1', 'Semester 2', 'Semester 3', 'Semester 4', 'Semester 5', 'Semester 6', 'Semester 7', 'Semester 8'];
  final List<String> _departments = ['Computer Science', 'Electronics', 'Mechanical', 'Civil', 'Electrical'];

  @override
  void dispose() {
    _examNameController.dispose();
    _examCodeController.dispose();
    _totalMarksController.dispose();
    _passingMarksController.dispose();
    _durationController.dispose();
    _roomNumberController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2026),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF283593),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF283593),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _saveExam() {
    if (_formKey.currentState!.validate()) {
      // Create exam object and save
      final examData = {
        'examName': _examNameController.text,
        'examCode': _examCodeController.text,
        'examType': _selectedExamType,
        'semester': _selectedSemester,
        'department': _selectedDepartment,
        'date': _selectedDate,
        'time': _selectedTime,
        'totalMarks': _totalMarksController.text,
        'passingMarks': _passingMarksController.text,
        'duration': _durationController.text,
        'roomNumber': _roomNumberController.text,
        'instructions': _instructionsController.text,
      };

      // Navigate back with exam data
      Navigator.pop(context, examData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Exam created successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Add New Exam',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF283593),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSectionTitle('Basic Information'),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _examNameController,
              label: 'Exam Name',
              hint: 'e.g., Data Structures Final Exam',
              icon: Icons.book_rounded,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter exam name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _examCodeController,
              label: 'Exam Code',
              hint: 'e.g., CS301',
              icon: Icons.code_rounded,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter exam code';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildDropdown(
              label: 'Exam Type',
              value: _selectedExamType,
              items: _examTypes,
              icon: Icons.category_rounded,
              onChanged: (value) {
                setState(() {
                  _selectedExamType = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            _buildDropdown(
              label: 'Semester',
              value: _selectedSemester,
              items: _semesters,
              icon: Icons.school_rounded,
              onChanged: (value) {
                setState(() {
                  _selectedSemester = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            _buildDropdown(
              label: 'Department',
              value: _selectedDepartment,
              items: _departments,
              icon: Icons.business_rounded,
              onChanged: (value) {
                setState(() {
                  _selectedDepartment = value!;
                });
              },
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Schedule'),
            const SizedBox(height: 12),
            _buildDateTimePicker(
              label: 'Exam Date',
              value: '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
              icon: Icons.calendar_today_rounded,
              onTap: () => _selectDate(context),
            ),
            const SizedBox(height: 16),
            _buildDateTimePicker(
              label: 'Exam Time',
              value: _selectedTime.format(context),
              icon: Icons.access_time_rounded,
              onTap: () => _selectTime(context),
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _durationController,
              label: 'Duration (in minutes)',
              hint: 'e.g., 180',
              icon: Icons.timer_rounded,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter duration';
                }
                if (int.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _roomNumberController,
              label: 'Room Number',
              hint: 'e.g., Room 101',
              icon: Icons.meeting_room_rounded,
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Marks'),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _totalMarksController,
              label: 'Total Marks',
              hint: 'e.g., 100',
              icon: Icons.star_rounded,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter total marks';
                }
                if (int.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _passingMarksController,
              label: 'Passing Marks',
              hint: 'e.g., 40',
              icon: Icons.check_circle_rounded,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter passing marks';
                }
                if (int.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Additional Information'),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _instructionsController,
              label: 'Instructions',
              hint: 'Enter exam instructions...',
              icon: Icons.info_rounded,
              maxLines: 4,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveExam,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF283593),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: const Text(
                'Create Exam',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 16),
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
        color: Color(0xFF283593),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            prefixIcon: Icon(icon, color: const Color(0xFF283593)),
            border: InputBorder.none,
            labelStyle: const TextStyle(color: Color(0xFF283593)),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required IconData icon,
    required void Function(String?) onChanged,
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
            prefixIcon: Icon(icon, color: const Color(0xFF283593)),
            border: InputBorder.none,
            labelStyle: const TextStyle(color: Color(0xFF283593)),
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildDateTimePicker({
    required String label,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF283593)),
        title: Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}

// Placeholder page class (if not already in your project)
class PlaceholderPage extends StatelessWidget {
  final String title;
  
  const PlaceholderPage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFF283593),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Text('$title Page'),
      ),
    );
  }
}