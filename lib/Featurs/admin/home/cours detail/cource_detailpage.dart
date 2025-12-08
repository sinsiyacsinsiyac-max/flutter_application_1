import 'package:flutter/material.dart';
import 'package:flutter_application_1/Featurs/admin/home/cours%20detail/cource_detailaddpage.dart';

class CourseManagementPage extends StatefulWidget {
  const CourseManagementPage({Key? key}) : super(key: key);

  @override
  State<CourseManagementPage> createState() => _CourseManagementPageState();
}

class _CourseManagementPageState extends State<CourseManagementPage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Course Management',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color.fromARGB(255, 96, 107, 236),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: courses.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: courses.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddCourseDetailsPage(
                          courcename: courses[index],
                        ),
                      ),
                    );
                  },
                  child: _buildCourseCard(context, courses[index], index),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showAddCourseDialog(context);
        },
        backgroundColor: const Color.fromARGB(255, 96, 108, 235),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Add Course',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.school_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No courses available',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the + button to add a course',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseCard(BuildContext context, String courseName, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 103, 114, 236).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.school_rounded, color: Color.fromARGB(255, 96, 106, 214)),
        ),
        title: Text(
          courseName,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          'Course #${index + 1}',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
           
            IconButton(
              icon: const Icon(Icons.delete, color: Color.fromARGB(255, 79, 125, 250)),
              onPressed: () {
                _showDeleteDialog(context, courseName, index);
              },
              tooltip: 'Delete',
            ),
          ],
        ),
      ),
    );
  }

  void _showAddCourseDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Course'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Course Name',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.school),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter a course name';
              }
              if (courses.contains(value.trim())) {
                return 'Course already exists';
              }
              return null;
            },
            textCapitalization: TextCapitalization.words,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                setState(() {
                  courses.add(controller.text.trim());
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${controller.text.trim()} added successfully'),
                    backgroundColor: const Color.fromARGB(255, 67, 137, 197),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 92, 120, 230),
              foregroundColor: Colors.white,
            ),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditCourseDialog(BuildContext context, String courseName, int index) {
    final TextEditingController controller = TextEditingController(text: courseName);
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Course'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Course Name',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.edit),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter a course name';
              }
              if (value.trim() != courseName && courses.contains(value.trim())) {
                return 'Course already exists';
              }
              return null;
            },
            textCapitalization: TextCapitalization.words,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                setState(() {
                  courses[index] = controller.text.trim();
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Course updated successfully'),
                    backgroundColor: Color.fromARGB(255, 83, 162, 240),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 97, 109, 240),
              foregroundColor: Colors.white,
            ),
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String courseName, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Course'),
        content: Text('Are you sure you want to delete "$courseName"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                courses.removeAt(index);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$courseName deleted successfully'),
                  backgroundColor: const Color.fromARGB(255, 93, 124, 237),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 66, 138, 219),
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

