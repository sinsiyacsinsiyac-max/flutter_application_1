// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/Featurs/auth/view/login_screen.dart';
// import 'package:flutter_application_1/Featurs/firebase_serviece/firebase.dart';
// import 'package:flutter_application_1/Featurs/view_more/course/course_detai_page.dart';

// import 'cours detail/cource_detailpage.dart';

// class AdminHomeScreen extends StatefulWidget {
//   const AdminHomeScreen({Key? key}) : super(key: key);

//   @override
//   State<AdminHomeScreen> createState() => _AdminHomeScreenState();
// }

// class _AdminHomeScreenState extends State<AdminHomeScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F7FA),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 2,
//         title: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: const Color(0xFF1A237E),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: const Icon(Icons.dashboard, color: Colors.white, size: 24),
//             ),
//             const SizedBox(width: 12),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: const [
//                 Text(
//                   'Admin Portal',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 Text(
//                   'College Management System',
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: Colors.grey,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         actions: [
//           Stack(
//             children: [
//               IconButton(
//                 icon: const Icon(Icons.notifications_outlined, color: Colors.black87),
//                 onPressed: () {},
//               ),
//               Positioned(
//                 right: 12,
//                 top: 12,
//                 child: Container(
//                   width: 8,
//                   height: 8,
//                   decoration: const BoxDecoration(
//                     color: Colors.red,
//                     shape: BoxShape.circle,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           IconButton(
//             icon: const Icon(Icons.settings_outlined, color: Colors.black87),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Welcome back, Admin!',
//               style: TextStyle(
//                 fontSize: 28,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//             const SizedBox(height: 4),
//             const Text(
//               'Manage your college portal',
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.grey,
//               ),
//             ),
//             const SizedBox(height: 24),
//             _buildMainCard(
//               title: 'Courses',
//               subtitle: 'Manage all courses and programs',
//               icon: Icons.school_rounded,
//               color: const Color(0xFF1A237E),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const CourseManagementPage()),
//                 );
//               },
//             ),
//             const SizedBox(height: 16),
//             _buildMainCard(
//               title: 'Admissions',
//               subtitle: 'Handle admission applications',
//               icon: Icons.person_add_rounded,
//               color: const Color(0xFF0D47A1),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const AdmissionManagementPage()),
//                 );
//               },
//             ),
//             const SizedBox(height: 16),
//             _buildMainCard(
//               title: 'Exams',
//               subtitle: 'Schedule and manage examinations',
//               icon: Icons.edit_note_rounded,
//               color: const Color(0xFF283593),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const ExamManagementPage()),
//                 );
//               },
//             ),
//             const SizedBox(height: 16),
//             _buildMainCard(
//               title: 'Downloads',
//               subtitle: 'Upload study materials and notes',
//               icon: Icons.download_rounded,
//               color: const Color(0xFF073D7A),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const DownloadsManagementPage()),
//                 );
//               },
//             ),
//             const SizedBox(height: 16),
//             _buildMainCard(
//               title: 'Events',
//               subtitle: 'Create and manage college events',
//               icon: Icons.event_rounded,
//               color: const Color(0xFF0F1A6E),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const EventsManagementPage()),
//                 );
//               },
//             ),
//             const SizedBox(height: 24),
//             Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.05),
//                     blurRadius: 10,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Quick Statistics',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       _buildStatItem('9', 'Courses', const Color(0xFF1A237E)),
//                       _buildStatItem('45', 'Students', const Color(0xFF0D47A1)),
//                       _buildStatItem('3', 'Exams', const Color(0xFF283593)),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//      floatingActionButton: FloatingActionButton.extended(
//   onPressed: () {
//   final AuthService _authService = AuthService();
//   _authService.signOut();
//   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>LoginScreen()), (route) => false,);
//   },
//   backgroundColor: Colors.red, // Changed to red for logout
//   icon: const Icon(Icons.logout_rounded, color: Colors.white),
//   label: const Text(
//     'Logout',
//     style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
//   ),
// ),
//     );
//   }

//   Widget _buildMainCard({
//     required String title,
//     required String subtitle,
//     required IconData icon,
//     required Color color,
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(16),
//       child: Container(
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           border: Border(
//             left: BorderSide(color: color, width: 5),
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.08),
//               blurRadius: 15,
//               offset: const Offset(0, 5),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: color.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Icon(icon, color: color, size: 32),
//             ),
//             const SizedBox(width: 20),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: color,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     subtitle,
//                     style: const TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Icon(
//               Icons.arrow_forward_ios,
//               color: Colors.grey.shade400,
//               size: 20,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStatItem(String count, String label, Color color) {
//     return Column(
//       children: [
//         Text(
//           count,
//           style: TextStyle(
//             fontSize: 32,
//             fontWeight: FontWeight.bold,
//             color: color,
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           label,
//           style: const TextStyle(
//             fontSize: 14,
//             color: Colors.grey,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ],
//     );
//   }
// }

//   Widget _buildCourseCard(BuildContext context, String courseName) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 12),
//       elevation: 3,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: ListTile(
//         contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//         leading: Container(
//           padding: const EdgeInsets.all(10),
//           decoration: BoxDecoration(
//             color: const Color(0xFF1A237E).withOpacity(0.1),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: const Icon(Icons.school_rounded, color: Color(0xFF1A237E)),
//         ),
//         title: Text(
//           courseName,
//           style: const TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         trailing: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             IconButton(
//               icon: const Icon(Icons.edit, color: Color(0xFF1A237E)),
//               onPressed: () {
//                 _showEditCourseDialog(context, courseName);
//               },
//             ),
//             IconButton(
//               icon: const Icon(Icons.delete, color: Colors.red),
//               onPressed: () {
//                 _showDeleteDialog(context, courseName);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showAddCourseDialog(BuildContext context) {
//     final TextEditingController controller = TextEditingController();
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Add New Course'),
//         content: TextField(
//           controller: controller,
//           decoration: const InputDecoration(
//             labelText: 'Course Name',
//             border: OutlineInputBorder(),
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text('${controller.text} added successfully')),
//               );
//             },
//             style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A237E)),
//             child: const Text('Add'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showEditCourseDialog(BuildContext context, String courseName) {
//     final TextEditingController controller = TextEditingController(text: courseName);
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Edit Course'),
//         content: TextField(
//           controller: controller,
//           decoration: const InputDecoration(
//             labelText: 'Course Name',
//             border: OutlineInputBorder(),
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text('Course updated successfully')),
//               );
//             },
//             style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A237E)),
//             child: const Text('Update'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showDeleteDialog(BuildContext context, String courseName) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Delete Course'),
//         content: Text('Are you sure you want to delete $courseName?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text('$courseName deleted successfully')),
//               );
//             },
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             child: const Text('Delete'),
//           ),
//         ],
//       ),
//     );
//   }

// class AdmissionManagementPage extends StatelessWidget {
//   const AdmissionManagementPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F7FA),
//       appBar: AppBar(
//         title: const Text(
//           'Admission Management',
//           style: TextStyle(fontWeight: FontWeight.w600),
//         ),
//         backgroundColor: const Color(0xFF0D47A1),
//         foregroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           _buildAdminCard(
//             context,
//             'Documents Required',
//             'Manage required documents',
//             Icons.description_rounded,
//             () {},
//           ),
//           const SizedBox(height: 12),
//           _buildAdminCard(
//             context,
//             'Contact Information',
//             'Update admission contacts',
//             Icons.phone_rounded,
//             () {},
//           ),
//           const SizedBox(height: 12),
//           _buildAdminCard(
//             context,
//             'Application Status',
//             'Track admission applications',
//             Icons.fact_check_rounded,
//             () {},
//           ),
//           const SizedBox(height: 12),
//           GestureDetector(
//             onTap: () {
//               Navigator.push(context, MaterialPageRoute(builder:(context) => AdmissionManagementPage()));
//             },
//             child: _buildAdminCard(
//               context,
//               'Admission Criteria',
//               'Set admission requirements',
//               Icons.rule_rounded,
//               () {},
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildAdminCard(
//     BuildContext context,
//     String title,
//     String subtitle,
//     IconData icon,
//     VoidCallback onTap,
//   ) {
//     return Card(
//       elevation: 3,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: ListTile(
//         onTap: onTap,
//         contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//         leading: Container(
//           padding: const EdgeInsets.all(10),
//           decoration: BoxDecoration(
//             color: const Color(0xFF0D47A1).withOpacity(0.1),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Icon(icon, color: const Color(0xFF0D47A1)),
//         ),
//         title: Text(
//           title,
//           style: const TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         subtitle: Text(subtitle),
//         trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//       ),
//     );
//   }
// }

// class ExamManagementPage extends StatelessWidget {
//   const ExamManagementPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F7FA),
//       appBar: AppBar(
//         title: const Text(
//           'Exam Management',
//           style: TextStyle(fontWeight: FontWeight.w600),
//         ),
//         backgroundColor: const Color(0xFF283593),
//         foregroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           GestureDetector(
//             onTap:() {
//               Navigator.push(context, MaterialPageRoute(builder:(context) => ExamManagementPage(),));
//             },
//         child: _buildExamCard(context, 'Time Table', Icons.calendar_today_rounded)),
//           const SizedBox(height: 12),
//           _buildExamCard(context, 'Seat Arrangements', Icons.event_seat_rounded),
//           const SizedBox(height: 12),
//           _buildExamCard(context, 'Exam Schedules', Icons.schedule_rounded),
//           const SizedBox(height: 12),
//           _buildExamCard(context, 'Results', Icons.assessment_rounded),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () {},
//         backgroundColor: const Color(0xFF283593),
//         icon: const Icon(Icons.add, color: Colors.white),
//         label: const Text(
//           'Create Exam',
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
//         ),
//       ),
//     );
//   }

//   Widget _buildExamCard(BuildContext context, String title, IconData icon) {
//     return Card(
//       elevation: 3,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: ListTile(
//         contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//         leading: Container(
//           padding: const EdgeInsets.all(10),
//           decoration: BoxDecoration(
//             color: const Color(0xFF283593).withOpacity(0.1),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Icon(icon, color: const Color(0xFF283593)),
//         ),
//         title: Text(
//           title,
//           style: const TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//         onTap: () {},
//       ),
//     );
//   }
// }

// class DownloadsManagementPage extends StatelessWidget {
//   const DownloadsManagementPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F7FA),
//       appBar: AppBar(
//         title: const Text(
//           'Downloads Management',
//           style: TextStyle(fontWeight: FontWeight.w600),
//         ),
//         backgroundColor: const Color(0xFF073D7A),
//         foregroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           GestureDetector(
//             onTap:() {
//               Navigator.push(context, MaterialPageRoute(builder:(context) => DownloadsManagementPage(),));
//             },
//             child:  _buildDownloadCard(context, 'Notes', Icons.notes_rounded)),
//           const SizedBox(height: 12),
//           _buildDownloadCard(context, 'Previous Question Papers', Icons.quiz_rounded),
//           const SizedBox(height: 12),
//           _buildDownloadCard(context, 'Syllabus', Icons.book_rounded),
//           const SizedBox(height: 12),
//           _buildDownloadCard(context, 'Study Materials', Icons.folder_rounded),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () {},
//         backgroundColor: const Color(0xFF073D7A),
//         icon: const Icon(Icons.upload_file, color: Colors.white),
//         label: const Text(
//           'Upload File',
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
//         ),
//       ),
//     );
//   }

//   Widget _buildDownloadCard(BuildContext context, String title, IconData icon) {
//     return Card(
//       elevation: 3,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: ListTile(
//         contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//         leading: Container(
//           padding: const EdgeInsets.all(10),
//           decoration: BoxDecoration(
//             color: const Color(0xFF073D7A).withOpacity(0.1),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Icon(icon, color: const Color(0xFF073D7A)),
//         ),
//         title: Text(
//           title,
//           style: const TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//         onTap: () {},
//       ),
//     );
//   }
// }

// class EventsManagementPage extends StatelessWidget {
//   const EventsManagementPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F7FA),
//       appBar: AppBar(
//         title: const Text(
//           'Events Management',
//           style: TextStyle(fontWeight: FontWeight.w600),
//         ),
//         backgroundColor: const Color(0xFF0F1A6E),
//         foregroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           GestureDetector(
//             onTap:() {
//               Navigator.push(context, MaterialPageRoute(builder:(context) => EventsManagementPage(),));
//             },
//             child:  _buildEventCard(context, 'Programs', Icons.event_rounded)),
//           const SizedBox(height: 12),
//           _buildEventCard(context, 'Upcoming Events', Icons.event_available),
//           const SizedBox(height: 12),
//           _buildEventCard(context, 'Photo Gallery', Icons.photo_library_rounded),
//           const SizedBox(height: 12),
//           _buildEventCard(context, 'Event Calendar', Icons.calendar_month_rounded),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () {},
//         backgroundColor: const Color(0xFF0F1A6E),
//         icon: const Icon(Icons.add, color: Colors.white),
//         label: const Text(
//           'Create Event',
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
//         ),
//       ),
//     );
//   }

//   Widget _buildEventCard(BuildContext context, String title, IconData icon) {
//     return Card(
//       elevation: 3,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: ListTile(
//         contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//         leading: Container(
//           padding: const EdgeInsets.all(10),
//           decoration: BoxDecoration(
//             color: const Color(0xFF0F1A6E).withOpacity(0.1),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Icon(icon, color: const Color(0xFF0F1A6E)),
//         ),
//         title: Text(
//           title,
//           style: const TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//         onTap: () {},
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Featurs/admin/college_datail_add.dart';
import 'package:flutter_application_1/Featurs/admin/home/admission%20detail/admissiondetail_page.dart';
import 'package:flutter_application_1/Featurs/admin/home/cours%20detail/cource_detailpage.dart';
import 'package:flutter_application_1/Featurs/admin/home/download%20details/downloaddetail_page.dart';
import 'package:flutter_application_1/Featurs/admin/home/evenet%20details/eventdetails_page.dart';
import 'package:flutter_application_1/Featurs/admin/home/exam%20detail/examdetail.page.dart';
import 'package:flutter_application_1/Featurs/admin/profile_screen.dart';
import 'package:flutter_application_1/Featurs/auth/view/login_screen.dart';
import 'package:flutter_application_1/Featurs/college/add_course.dart';
import 'package:flutter_application_1/Featurs/college/add_event.dart';
import 'package:flutter_application_1/Featurs/college/aminities_add_option.dart';
import 'package:flutter_application_1/Featurs/firebase_serviece/firebase.dart';
import 'package:flutter_application_1/Featurs/view_more/course/course_detai_page.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({Key? key}) : super(key: key);

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  final AuthService _authService = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  int _usersCount = 0;
  int _teacheCount = 0;
  int _courseCount = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future _loadData() async {
    final usersQuery = await _firestore
        .collection('users')
        .where('role', isEqualTo: 'user')
        .get();
    final teachersQuery = await _firestore
        .collection('users')
        .where('role', isEqualTo: 'teacher')
        .get();
    final courseQuery = await _firestore.collection('courses').get();
    setState(() {
      _usersCount = usersQuery.size;
      _teacheCount = teachersQuery.size;
      _courseCount = courseQuery.size;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF1A237E),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.dashboard, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Admin Portal',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  'College Management System',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: Colors.black87,
                ),
                onPressed: () {},
              ),
              Positioned(
                right: 12,
                top: 12,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.black87),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome back, Admin!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Manage your college portal',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // User Management Card
            // Add this to your AdminHomeScreen after the User Management card
            _buildMainCard(
              title: 'College Details',
              subtitle: 'Manage college contact information',
              icon: Icons.business_rounded,
              color: const Color(0xFF00695C),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CollegeDetailsPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildMainCard(
              title: 'User Management',
              subtitle: 'Manage users, colleges and teachers',
              icon: Icons.people_alt_rounded,
              color: const Color(0xFF4A148C),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserManagementPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            _buildMainCard(
              title: 'Courses',
              subtitle: 'Manage all courses and programs',
              icon: Icons.school_rounded,
              color: const Color(0xFF1A237E),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TeacherCoursePanel()),
                );
              },
            ),
            const SizedBox(height: 16),

            // _buildMainCard(
            //   title: 'Exams',
            //   subtitle: 'Schedule and manage examinations',
            //   icon: Icons.edit_note_rounded,
            //   color: const Color(0xFF283593),
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => const ExamManagementPage()),
            //     );
            //   },
            // ),
            const SizedBox(height: 16),

            _buildMainCard(
              title: 'Aminities',
              subtitle: 'Upload College  Aminities',
              icon: Icons.category,
              color: const Color(0xFF073D7A),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CollegeAmenitiesPanel(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            _buildMainCard(
              title: 'Events',
              subtitle: 'Create and manage college events',
              icon: Icons.event_rounded,
              color: const Color(0xFF0F1A6E),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CollegeEventsPanel(),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Quick Statistics',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(
                        _courseCount,
                        'Courses',
                        const Color(0xFF1A237E),
                      ),
                      _buildStatItem(
                        _usersCount,
                        'Students',
                        const Color(0xFF0D47A1),
                      ),
                      _buildStatItem(
                        _teacheCount,
                        'Teachers',
                        const Color(0xFF4A148C),
                      ),
                      // _buildStatItem('3', 'Colleges', const Color(0xFF283593)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () {
      //     _authService.signOut();
      //     Navigator.pushAndRemoveUntil(
      //       context,
      //       MaterialPageRoute(builder: (context) => const LoginScreen()),
      //       (route) => false,
      //     );
      //   },
      //   backgroundColor: Colors.red,
      //   icon: const Icon(Icons.logout_rounded, color: Colors.white),
      //   label: const Text(
      //     'Logout',
      //     style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      //   ),
      // ),
    );
  }

  Widget _buildMainCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border(left: BorderSide(color: color, width: 5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey.shade400,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(int count, String label, Color color) {
    return Column(
      children: [
        Text(
          '${count}',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({Key? key}) : super(key: key);

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  final AuthService _authService = AuthService();
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'all';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'User Management',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF4A148C),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search and Filter Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Search users...',
                        prefixIcon: Icon(Icons.search),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedFilter,
                        items: const [
                          DropdownMenuItem(
                            value: 'all',
                            child: Text('All Users'),
                          ),
                          DropdownMenuItem(
                            value: 'teacher',
                            child: Text('Teachers'),
                          ),
                          DropdownMenuItem(
                            value: 'college',
                            child: Text('Colleges'),
                          ),
                          DropdownMenuItem(
                            value: 'user',
                            child: Text('Students'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedFilter = value!;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Users List
          Expanded(
            child: StreamBuilder(
              stream: _selectedFilter == 'all'
                  ? _authService.getUsers()
                  : _authService.getUsersByRole(_selectedFilter),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final users = snapshot.data?.docs ?? [];

                if (users.isEmpty) {
                  return const Center(
                    child: Text(
                      'No users found',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    final userData = user.data() as Map<String, dynamic>;

                    // Filter by search
                    final searchTerm = _searchController.text.toLowerCase();
                    if (searchTerm.isNotEmpty &&
                        !userData['username'].toString().toLowerCase().contains(
                          searchTerm,
                        ) &&
                        !userData['email'].toString().toLowerCase().contains(
                          searchTerm,
                        )) {
                      return const SizedBox.shrink();
                    }

                    return _buildUserCard(userData, context);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showAddUserDialog(context);
        },
        backgroundColor: const Color(0xFF4A148C),
        icon: const Icon(Icons.person_add, color: Colors.white),
        label: const Text(
          'Add User',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildUserCard(Map<String, dynamic> userData, BuildContext context) {
    Color roleColor;
    IconData roleIcon;

    switch (userData['role']) {
      case 'admin':
        roleColor = Colors.red;
        roleIcon = Icons.admin_panel_settings;
        break;
      case 'college':
        roleColor = Colors.orange;
        roleIcon = Icons.school;
        break;
      case 'teacher':
        roleColor = Colors.green;
        roleIcon = Icons.person;
        break;
      default:
        roleColor = Colors.blue;
        roleIcon = Icons.person_outline;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: roleColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(roleIcon, color: roleColor),
        ),
        title: Text(
          userData['username'] ?? 'No Name',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(userData['email'] ?? 'No Email'),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: roleColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                userData['role']?.toString().toUpperCase() ?? 'USER',
                style: TextStyle(
                  fontSize: 10,
                  color: roleColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, size: 20),
                  SizedBox(width: 8),
                  Text('Edit Role'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 20, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Delete', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
          onSelected: (value) {
            if (value == 'edit') {
              _showEditRoleDialog(context, userData);
            } else if (value == 'delete') {
              _showDeleteUserDialog(context, userData);
            }
          },
        ),
      ),
    );
  }

  void _showAddUserDialog(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    String selectedRole = 'teacher';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New User'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedRole,
                decoration: const InputDecoration(
                  labelText: 'Role',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'teacher', child: Text('Teacher')),
                  DropdownMenuItem(value: 'college', child: Text('College')),
                  DropdownMenuItem(value: 'user', child: Text('Student')),
                ],
                onChanged: (value) {
                  selectedRole = value!;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await _authService.createUserWithRole(
                  email: emailController.text.trim(),
                  password: passwordController.text.trim(),
                  username: usernameController.text.trim(),
                  role: selectedRole,
                  createdBy: FirebaseAuth.instance.currentUser!.uid,
                );

                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('User created successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4A148C),
            ),
            child: const Text('Create User'),
          ),
        ],
      ),
    );
  }

  void _showEditRoleDialog(
    BuildContext context,
    Map<String, dynamic> userData,
  ) {
    String newRole = userData['role'] ?? 'user';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit User Role'),
        content: DropdownButtonFormField<String>(
          value: newRole,
          items: const [
            DropdownMenuItem(value: 'teacher', child: Text('Teacher')),
            DropdownMenuItem(value: 'college', child: Text('College')),
            DropdownMenuItem(value: 'user', child: Text('Student')),
          ],
          onChanged: (value) {
            newRole = value!;
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await _authService.updateUserRole(userData['uid'], newRole);

                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('User role updated successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4A148C),
            ),
            child: const Text('Update Role'),
          ),
        ],
      ),
    );
  }

  void _showDeleteUserDialog(
    BuildContext context,
    Map<String, dynamic> userData,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User'),
        content: Text(
          'Are you sure you want to delete ${userData['username']}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await _authService.deleteUser(userData['uid']);

                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('User deleted successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
