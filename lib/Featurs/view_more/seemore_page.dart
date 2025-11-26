import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Featurs/auth/view/login_screen.dart';
import 'package:flutter_application_1/Featurs/firebase_serviece/firebase.dart';
import 'package:flutter_application_1/Featurs/view_more/admission/admission_page.dart';
import 'package:flutter_application_1/Featurs/view_more/course/course_detai_page.dart';
import 'package:flutter_application_1/Featurs/view_more/downloads/downloads_page.dart';
import 'package:flutter_application_1/Featurs/view_more/downloads/question_and_answers.dart';
import 'package:flutter_application_1/Featurs/view_more/events/events_page.dart';
import 'package:flutter_application_1/Featurs/view_more/events/photo_gallery.dart'
    hide EventsPage;
import 'package:flutter_application_1/Featurs/view_more/exam/exam_page.dart';
import 'package:flutter_application_1/Featurs/view_more/profile/user_profile_screen.dart';

class ExpantioList extends StatelessWidget {
  const ExpantioList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthService _authService = AuthService();
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'College Portal',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            letterSpacing: 0.5,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 21, 133, 223),
        foregroundColor: Colors.white,
        elevation: 4,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.grey[50]!, Colors.grey[100]!],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            const SizedBox(height: 8),
            _buildWelcomeCard(),
            const SizedBox(height: 24),
            const ProfileExpantion(),
            const SizedBox(height: 16),
            const CoursesExpansion(),
            const SizedBox(height: 16),
            const AdmissionsExpansion(),
            const SizedBox(height: 16),
            const ExamsExpantion(),
            const SizedBox(height: 16),
            const DownloadsExpansion(),
            const SizedBox(height: 16),
            const EventsExpansion(),
            const SizedBox(height: 24),
            _buildLogoutButton(context, _authService),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        backgroundColor: const Color(0xFF1A237E),
        child: const Icon(Icons.home_rounded, color: Colors.white, size: 28),
        elevation: 4,
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Card(
      elevation: 6,
      shadowColor: Colors.blue.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [const Color(0xFF1A237E), Colors.blue[700]!],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.school_rounded,
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome Back!',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Manage your academic journey',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
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

  Widget _buildLogoutButton(BuildContext context, AuthService authService) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Material(
        borderRadius: BorderRadius.circular(16),
        elevation: 4,
        child: InkWell(
          onTap: () async {
            await _showLogoutDialog(context, authService);
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color.fromARGB(255, 17, 139, 239)!, const Color.fromARGB(255, 43, 137, 237)!],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 61, 127, 241).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.logout_rounded, color: Colors.white, size: 22),
                const SizedBox(width: 12),
                Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showLogoutDialog(
    BuildContext context,
    AuthService authService,
  ) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.logout_rounded, color: const Color.fromARGB(255, 55, 134, 231), size: 24),
            const SizedBox(width: 12),
            Text(
              'Logout',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: const Color.fromARGB(255, 40, 139, 221),
              ),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await authService.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 45, 167, 248),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class CoursesExpansion extends StatelessWidget {
  const CoursesExpansion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _ExpansionCard(
      icon: Icons.school_rounded,
      title: 'Courses',
      subtitleBuilder: (context) => StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('courses').snapshots(),
        builder: (context, snapshot) {
          final courseCount = snapshot.data?.docs.length ?? 0;
          return Text(
            '$courseCount programs available',
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          );
        },
      ),
      color: const Color(0xFF1A237E),
      childrenBuilder: (context) => [
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('courses').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return _buildErrorState('Error loading courses');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingState();
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return _buildEmptyState('No courses available');
            }

            final courses = snapshot.data!.docs;
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: courses.length,
              itemBuilder: (context, index) => _buildCourseItem(
                context,
                courses[index],
                index,
                courses.length,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCourseItem(
    BuildContext context,
    QueryDocumentSnapshot doc,
    int index,
    int total,
  ) {
    final course = doc.data() as Map<String, dynamic>;
    final courseId = doc.id;
    final courseName = course['name'] ?? 'Unnamed Course';
    final courseCode = course['code'] ?? '';
    final hasFees = course['hasFees'] == true;
    final totalFees = course['totalFees']?.toStringAsFixed(0) ?? '0';

    return AnimatedContainer(
      duration: Duration(milliseconds: 200 + (index * 100)),
      curve: Curves.easeInOut,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _navigateToCourseDetails(context, course, courseId);
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            margin: EdgeInsets.only(bottom: index == total - 1 ? 0 : 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color.fromARGB(255, 42, 109, 210).withOpacity(0.8),
                        const Color.fromARGB(255, 43, 101, 227),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.menu_book_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        courseName,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (courseCode.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          courseCode,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (hasFees) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.green.shade500, Colors.green.shade700],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '₹$totalFees',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToCourseDetails(
    BuildContext context,
    Map<String, dynamic> course,
    String courseId,
  ) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            CourseDetailsPage(
              courseId: courseId,
              courseName: course['name'] ?? 'Unnamed Course',
              courseCode: course['code'] ?? '',
              department: course['department'] ?? '',
              credits: course['credits']?.toString() ?? '',
              description: course['description'] ?? '',
              hasFees: course['hasFees'] ?? false,
              totalFees: course['totalFees']?.toString() ?? '0',
              semesterFees: course['semesterFees']?.toString() ?? '0',
              maxStudents: course['maxStudents']?.toString() ?? '0',
              enrolledStudents: course['enrolledStudents']?.toString() ?? '0',
            ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }
}

class AdmissionsExpansion extends StatelessWidget {
  const AdmissionsExpansion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _ExpansionCard(
      icon: Icons.assignment_rounded,
      title: 'Admissions',
      subtitle: 'Application info & requirements',
      color: const Color.fromARGB(255, 19, 99, 220),
      childrenBuilder: (context) => [
        _buildAdmissionItem(
          context,
          'Documents & Requirements',
          Icons.description_rounded,
          const Color.fromARGB(255, 31, 105, 215),
        ),
        _buildAdmissionItem(
          context,
          'Contact Information',
          Icons.phone_rounded,
          const Color(0xFF1565C0),
        ),
      ],
    );
  }

  Widget _buildAdmissionItem(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
  ) {
    return Material(
      color: const Color.fromARGB(0, 28, 34, 126),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AdmissionPage(collegeId: 'colleges'),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileExpantion extends StatelessWidget {
  const ProfileExpantion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(20),
      elevation: 6,
      shadowColor: Colors.blue.withOpacity(0.2),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  UserProfileScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    const begin = Offset(0.0, 1.0);
                    const end = Offset.zero;
                    const curve = Curves.easeInOut;
                    var tween = Tween(
                      begin: begin,
                      end: end,
                    ).chain(CurveTween(curve: curve));
                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  },
            ),
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [const Color(0xFF0D47A1), Colors.blue[700]!],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Profile',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'View and update your information',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ExamsExpantion extends StatelessWidget {
  const ExamsExpantion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _ExpansionCard(
      icon: Icons.edit_note_rounded,
      title: 'Exams',
      subtitle: 'Schedule & seat arrangements',
      color: const Color.fromARGB(255, 87, 104, 234),
      childrenBuilder: (context) => [
        _buildExamItem(
          context,
          'Time Table & Schedule',
          Icons.calendar_today_rounded,
          Colors.blue,
        ),
        _buildExamItem(
          context,
          'Seat Arrangements',
          Icons.event_seat_rounded,
          const Color.fromARGB(255, 88, 96, 241),
        ),
      ],
    );
  }

  Widget _buildExamItem(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ExamPage()),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DownloadsExpansion extends StatelessWidget {
  const DownloadsExpansion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _ExpansionCard(
      icon: Icons.download_rounded,
      title: 'Downloads',
      subtitleBuilder: (context) => StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('study_materials')
            .snapshots(),
        builder: (context, snapshot) {
          final totalCount = snapshot.data?.docs.length ?? 0;
          return Text(
            '$totalCount study materials available',
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          );
        },
      ),
      color: const Color.fromARGB(255, 90, 79, 240),
      childrenBuilder: (context) => [
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('study_materials')
              .snapshots(),
          builder: (context, snapshot) {
            final notesCount =
                snapshot.data?.docs
                    .where(
                      (doc) =>
                          (doc.data() as Map<String, dynamic>)['type'] ==
                          'notes',
                    )
                    .length ??
                0;
            final papersCount =
                snapshot.data?.docs
                    .where(
                      (doc) =>
                          (doc.data() as Map<String, dynamic>)['type'] ==
                          'papers',
                    )
                    .length ??
                0;

            return Column(
              children: [
                _buildDownloadItem(
                  context,
                  'Study Notes',
                  Icons.note_rounded,
                  const Color.fromARGB(255, 57, 78, 216),
                  notesCount,
                  const NotesDownloadPage(),
                ),
                _buildDownloadItem(
                  context,
                  'Previous Question Papers',
                  Icons.quiz_rounded,
                  const Color.fromARGB(255, 66, 96, 234),
                  papersCount,
                  const PreviousQuestionPapersPage(),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildDownloadItem(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    int count,
    Widget page,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$count files available',
                      style: TextStyle(fontSize: 12, color: const Color.fromARGB(255, 86, 95, 222)),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  count.toString(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EventsExpansion extends StatelessWidget {
  const EventsExpansion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _ExpansionCard(
      icon: Icons.event_rounded,
      title: 'Events & Gallery',
      subtitle: 'Upcoming activities & photos',
      color: const Color.fromARGB(255, 61, 128, 228),
      childrenBuilder: (context) => [
        _buildEventItem(
          context,
          'Photo Gallery',
          Icons.photo_library_rounded,
          const Color.fromARGB(255, 55, 145, 228),
          const PhotoGalleryList(),
        ),
        _buildEventItem(
          context,
          'Events & Announcements',
          Icons.event_available_rounded,
          const Color.fromARGB(255, 58, 131, 183),
          const EventsPage(),
        ),
      ],
    );
  }

  Widget _buildEventItem(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    Widget page,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Reusable Expansion Card Widget
class _ExpansionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget Function(BuildContext)? subtitleBuilder;
  final Color color;
  final List<Widget> Function(BuildContext) childrenBuilder;

  const _ExpansionCard({
    required this.icon,
    required this.title,
    this.subtitle,
    this.subtitleBuilder,
    required this.color,
    required this.childrenBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shadowColor: color.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          leading: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [color.withOpacity(0.9), color]),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: color,
              letterSpacing: 0.5,
            ),
          ),
          subtitle: subtitleBuilder != null
              ? subtitleBuilder!(context)
              : Text(
                  subtitle ?? '',
                  style: TextStyle(fontSize: 13, color: const Color.fromARGB(255, 123, 129, 225)),
                ),
          children: [
            const Divider(height: 1, thickness: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: childrenBuilder(context)),
            ),
          ],
        ),
      ),
    );
  }
}

// Utility Widgets
Widget _buildLoadingState() {
  return Padding(
    padding: const EdgeInsets.all(24),
    child: Center(
      child: Column(
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(
                const Color(0xFF1A237E).withOpacity(0.7),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Loading...',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    ),
  );
}

Widget _buildErrorState(String message) {
  return Padding(
    padding: const EdgeInsets.all(24),
    child: Column(
      children: [
        Icon(Icons.error_outline_rounded, color: Colors.red[400], size: 48),
        const SizedBox(height: 12),
        Text(
          message,
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

Widget _buildEmptyState(String message) {
  return Padding(
    padding: const EdgeInsets.all(24),
    child: Column(
      children: [
        Icon(Icons.inbox_rounded, color: Colors.grey[400], size: 48),
        const SizedBox(height: 12),
        Text(
          message,
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
