import 'package:flutter/material.dart';

class AddAdmissionPage extends StatefulWidget {
  const AddAdmissionPage({Key? key}) : super(key: key);

  @override
  State<AddAdmissionPage> createState() => _AddAdmissionPageState();
}

class _AddAdmissionPageState extends State<AddAdmissionPage> {
  final _formKey = GlobalKey<FormState>();
  
  // Single controllers
  final _controllers = <String, TextEditingController>{
    'title': TextEditingController(),
    'course': TextEditingController(),
    'description': TextEditingController(),
    'duration': TextEditingController(),
    'eligibility': TextEditingController(),
    'appFee': TextEditingController(),
    'courseFee': TextEditingController(),
    'intake': TextEditingController(),
    'contact': TextEditingController(),
    'email': TextEditingController(),
    'phone': TextEditingController(),
  };
  
  // Dynamic lists
  final _documents = <TextEditingController>[TextEditingController()];
  final _criteria = <TextEditingController>[TextEditingController()];
  final _dates = <Map<String, TextEditingController>>[
    {'name': TextEditingController(), 'date': TextEditingController()}
  ];
  
  DateTime? _startDate, _endDate;
  String _admissionType = 'Regular';
  String _applicationMode = 'Online';
  bool _scholarshipAvailable = false;

  @override
  void dispose() {
    _controllers.values.forEach((c) => c.dispose());
    _documents.forEach((c) => c.dispose());
    _criteria.forEach((c) => c.dispose());
    _dates.forEach((d) => d.values.forEach((c) => c.dispose()));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Add New Admission', style: TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: const Color(0xFF0D47A1),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildCard('Basic Information', Icons.info_rounded, 0xFF0D47A1, [
              _buildTextField('title', 'Admission Title', 'e.g., BCA Admission 2024-25', Icons.title_rounded),
              _buildTextField('course', 'Course Name', 'e.g., Bachelor of Computer Applications', Icons.school_rounded),
              _buildTextField('description', 'Description', 'Brief description...', Icons.description_rounded, maxLines: 3),
            ]),
            _buildCard('Admission Details', Icons.settings_rounded, 0xFF1565C0, [
              _buildDropdown('Admission Type', _admissionType, ['Regular', 'Merit-Based', 'Entrance Exam', 'Management Quota'], (v) => setState(() => _admissionType = v!), Icons.category_rounded),
              _buildDropdown('Application Mode', _applicationMode, ['Online', 'Offline', 'Both'], (v) => setState(() => _applicationMode = v!), Icons.computer_rounded),
              _buildTextField('duration', 'Course Duration', 'e.g., 3 Years', Icons.schedule_rounded),
              _buildTextField('intake', 'Total Intake', 'e.g., 60', Icons.people_rounded, isNumber: true),
              _buildDatePicker('Application Start Date', _startDate, (d) => setState(() => _startDate = d)),
              _buildDatePicker('Application End Date', _endDate, (d) => setState(() => _endDate = d), minDate: _startDate),
            ]),
            _buildDynamicCard('Required Documents', Icons.description_rounded, 0xFF00695C, _documents),
            _buildCard('Admission Criteria', Icons.rule_rounded, 0xFF283593, [
              _buildTextField('eligibility', 'Basic Eligibility', 'e.g., 10+2 with 50% marks', Icons.check_circle_rounded),
              const SizedBox(height: 12),
              Text('Additional Criteria:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey[700])),
              const SizedBox(height: 8),
              ..._buildDynamicFields(_criteria),
            ]),
            _buildImportantDatesCard(),
            _buildCard('Fee Structure', Icons.payments_rounded, 0xFFD32F2F, [
              _buildTextField('appFee', 'Application Fee', 'e.g., ₹500', Icons.currency_rupee, isNumber: true),
              _buildTextField('courseFee', 'Total Course Fee', 'e.g., ₹45,000 per year', Icons.account_balance_rounded, isNumber: true),
              SwitchListTile(
                title: const Text('Scholarships Available'),
                value: _scholarshipAvailable,
                onChanged: (v) => setState(() => _scholarshipAvailable = v),
                activeColor: Colors.green[700],
                contentPadding: EdgeInsets.zero,
              ),
            ]),
            _buildCard('Contact Information', Icons.contact_phone_rounded, 0xFF6A1B9A, [
              _buildTextField('contact', 'Contact Person', 'e.g., Dr. John Doe', Icons.person_rounded),
              _buildTextField('email', 'Email', 'e.g., admissions@college.edu', Icons.email_rounded, isEmail: true),
              _buildTextField('phone', 'Phone Number', 'e.g., +91 1234567890', Icons.phone_rounded, isNumber: true),
            ]),
            const SizedBox(height: 16),
            _buildSubmitButton(),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String title, IconData icon, int color, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                      color: Color(color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: Color(color), size: 24),
                  ),
                  const SizedBox(width: 12),
                  Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(color))),
                ],
              ),
              const SizedBox(height: 20),
              ...children.map((w) => Padding(padding: const EdgeInsets.only(bottom: 16.0), child: w)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDynamicCard(String title, IconData icon, int color, List<TextEditingController> controllers) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                      color: Color(color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: Color(color), size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(color)))),
                  IconButton(
                    icon: Icon(Icons.add_circle_outline, color: Color(color)),
                    onPressed: () => setState(() => controllers.add(TextEditingController())),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ..._buildDynamicFields(controllers),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildDynamicFields(List<TextEditingController> controllers) {
    return controllers.asMap().entries.map((entry) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: entry.value,
                decoration: InputDecoration(
                  hintText: 'Enter item',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
            if (controllers.length > 1)
              IconButton(
                icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                onPressed: () => setState(() {
                  controllers[entry.key].dispose();
                  controllers.removeAt(entry.key);
                }),
              ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildImportantDatesCard() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                    child: const Icon(Icons.event_note_rounded, color: Color(0xFFE65100), size: 24),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(child: Text('Important Dates', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFE65100)))),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline, color: Color(0xFFE65100)),
                    onPressed: () => setState(() => _dates.add({'name': TextEditingController(), 'date': TextEditingController()})),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ..._dates.asMap().entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: entry.value['name'],
                          decoration: InputDecoration(
                            hintText: 'Event name',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          controller: entry.value['date'],
                          decoration: InputDecoration(
                            hintText: 'Date',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                      if (_dates.length > 1)
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                          onPressed: () => setState(() {
                            entry.value.values.forEach((c) => c.dispose());
                            _dates.removeAt(entry.key);
                          }),
                        ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String key, String label, String hint, IconData icon, {int maxLines = 1, bool isNumber = false, bool isEmail = false}) {
    return TextFormField(
      controller: _controllers[key],
      maxLines: maxLines,
      keyboardType: isNumber ? TextInputType.number : (isEmail ? TextInputType.emailAddress : TextInputType.text),
      decoration: InputDecoration(
        labelText: '$label *',
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) {
        if (value?.isEmpty ?? true) return 'Required';
        if (isEmail && !value!.contains('@')) return 'Invalid email';
        return null;
      },
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items, Function(String?) onChanged, IconData icon) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: '$label *',
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
      ),
      items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildDatePicker(String label, DateTime? date, Function(DateTime) onSelect, {DateTime? minDate}) {
    return InkWell(
      onTap: () async {
        final selected = await showDatePicker(
          context: context,
          initialDate: minDate ?? DateTime.now(),
          firstDate: minDate ?? DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (selected != null) onSelect(selected);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: '$label *',
          prefixIcon: const Icon(Icons.calendar_today_rounded),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.white,
        ),
        child: Text(
          date != null ? '${date.day}/${date.month}/${date.year}' : 'Select date',
          style: TextStyle(color: date != null ? Colors.black : Colors.grey),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF0D47A1), Color(0xFF1565C0)]),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: const Color(0xFF0D47A1).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: ElevatedButton(
        onPressed: _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: const Text('Create Admission', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
      ),
    );
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;
    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both start and end dates'), backgroundColor: Colors.red),
      );
      return;
    }

    final data = {
      'title': _controllers['title']!.text,
      'courseName': _controllers['course']!.text,
      'description': _controllers['description']!.text,
      'type': _admissionType,
      'mode': _applicationMode,
      'duration': _controllers['duration']!.text,
      'intake': _controllers['intake']!.text,
      'startDate': _startDate,
      'endDate': _endDate,
      'eligibility': _controllers['eligibility']!.text,
      'documents': _documents.map((c) => c.text).where((t) => t.isNotEmpty).toList(),
      'criteria': _criteria.map((c) => c.text).where((t) => t.isNotEmpty).toList(),
      'importantDates': _dates.map((d) => {'event': d['name']!.text, 'date': d['date']!.text}).where((d) => d['event']!.isNotEmpty).toList(),
      'applicationFee': _controllers['appFee']!.text,
      'courseFee': _controllers['courseFee']!.text,
      'scholarshipAvailable': _scholarshipAvailable,
      'contactPerson': _controllers['contact']!.text,
      'email': _controllers['email']!.text,
      'phone': _controllers['phone']!.text,
    };

    print('Admission Data: $data');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Admission created successfully!'), backgroundColor: Color(0xFF00695C)),
    );
    Navigator.pop(context);
  }
}