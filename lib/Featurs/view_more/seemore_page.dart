import 'package:flutter/material.dart';
import 'package:flutter_application_1/Featurs/auth/view/login_screen.dart';
import 'package:flutter_application_1/Featurs/firebase_serviece/firebase.dart';
import 'package:flutter_application_1/Featurs/view_more/admission/admission_page.dart';
import 'package:flutter_application_1/Featurs/view_more/course/course_detai_page.dart';
import 'package:flutter_application_1/Featurs/view_more/downloads/downloads_page.dart';
import 'package:flutter_application_1/Featurs/view_more/downloads/question_and_answers.dart';
import 'package:flutter_application_1/Featurs/view_more/events/events_page.dart';
import 'package:flutter_application_1/Featurs/view_more/events/photo_gallery.dart' hide EventsPage;
import 'package:flutter_application_1/Featurs/view_more/exam/exam_page.dart';

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
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const CoursesExpansion(),
          const SizedBox(height: 12),
          const AdmissionsExpansion(),
          const SizedBox(height: 12),
          const ExamsExpantion(),
          const SizedBox(height: 12),
          const DownloadsExpantion(),
          const SizedBox(height: 12),
          const EventsExpansion(),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () async{
              await _authService.signOut();
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>
              LoginScreen()), (route) => false,);
            },
            child: Container(
              padding: EdgeInsets.all(10),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.red,
                border: Border.all(
                  color:Colors.blueAccent 
                )
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout,color: Colors.white,),
                  Text('Logout',style: TextStyle(
                    color: Colors.white
                  ),)
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        backgroundColor: const Color(0xFF1A237E),
        child: const Icon(Icons.home_rounded, color: Colors.white),
      ),
    );
  }
}

class CoursesExpansion extends StatelessWidget {
  const CoursesExpansion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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

    return Card(
      elevation: 10,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF1A237E).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.school_rounded, color: Color(0xFF1A237E), size: 24),
          ),
          title: const Text(
            'Courses',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A237E),
            ),
          ),
          subtitle: Text(
            '${courses.length} programs',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
            ),
          ),
          children: [
            const Divider(height: 1),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: courses.length,
              itemBuilder: (context, index) {
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CourseDetailsPage(courseName:'BCA',)));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A237E),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            courses[index],
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[400]),
                          
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AdmissionsExpansion extends StatelessWidget {
  const AdmissionsExpansion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> admissions = [
      {'title': 'Documents', 'icon': Icons.description_rounded},
      {'title': 'Contact Number', 'icon': Icons.phone_rounded},
    ];

    return Card(
      elevation: 10,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF0D47A1).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.assignment_rounded, color: Color(0xFF0D47A1), size: 24),
          ),
          title: const Text(
            'Admissions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0D47A1),
            ),
          ),
          subtitle: Text(
            'Application info',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
            ),
          ),
          children: [
            const Divider(height: 1),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: admissions.length,
              itemBuilder: (context, index) {
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder:(context) =>AdmissionPage()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      child: Row(
                        children: [
                          Icon(
                            admissions[index]['icon'],
                            size: 22,
                            color: const Color(0xFF0D47A1),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            admissions[index]['title'],
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[400]),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ExamsExpantion extends StatelessWidget {
  const ExamsExpantion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> exams = [
      {'title': 'Time Table', 'icon': Icons.calendar_today_rounded},
      {'title': 'Seat Arrangements', 'icon': Icons.event_seat_rounded},
    ];

    return Card(
      elevation: 10,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF283593).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.edit_note_rounded, color: Color(0xFF283593), size: 24),
          ),
          title: const Text(
            'Exams',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF283593),
            ),
          ),
          subtitle: Text(
            'Schedule & details',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
            ),
          ),
          children: [
            const Divider(height: 1),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: exams.length,
              itemBuilder: (context, index) {
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder:(context) => ExamPage()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      child: Row(
                        children: [
                          Icon(
                            exams[index]['icon'],
                            size: 22,
                            color: const Color(0xFF283593),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            exams[index]['title'],
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[400]),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DownloadsExpantion extends StatelessWidget {
  const DownloadsExpantion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> downloads = [
      {'title': 'Notes', 'icon': Icons.notes_rounded,'page':NotesDownloadPage()},
      {'title': 'Previous Question Papers', 'icon': Icons.quiz_rounded,'page':PreviousQuestionPapersPage()},

    ];

    return Card(
      elevation: 10,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 7, 61, 122).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.download_rounded, color: Color.fromARGB(255, 8, 62, 123), size: 24),
          ),
          title: const Text(
            'Downloads',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color.fromARGB(255, 7, 52, 102),
            ),
          ),
          subtitle: Text(
            'Study materials',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
            ),
          ),
          children: [
            const Divider(height: 1),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: downloads.length,
              itemBuilder: (context, index) {
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder:(context) =>downloads[index]['page']));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      child: Row(
                        children: [
                          Icon(
                            downloads[index]['icon'],
                            size: 22,
                            color: const Color.fromARGB(255, 5, 50, 100),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              downloads[index]['title'],
                              style: const TextStyle( 
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[400]),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class EventsExpansion extends StatelessWidget {
  const EventsExpansion({Key? key}) : super(key: key);
  
  
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> events = [
      {
        'title': 'Programs',
        'icon': Icons.event_rounded,
        'page': const PhotoGalleryList()
      },
      {
        'title': 'Up-coming Event',
        'icon': Icons.event_available,
        'page': const EventsPage()
      },
    ];

    return Card(
      elevation: 10,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF283593).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.mic,
                color: Color.fromARGB(255, 11, 22, 100), size: 24),
          ),
          title: const Text(
            'Events',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color.fromARGB(255, 15, 26, 110),
            ),
          ),
          subtitle: Text(
            'Upcoming activities',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
            ),
          ),
          children: [
            const Divider(height: 1),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: events.length,
              itemBuilder: (context, index) {
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => events[index]['page'],
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      child: Row(
                        children: [
                          Icon(
                            events[index]['icon'],
                            size: 22,
                            color: const Color.fromARGB(255, 3, 14, 97),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            events[index]['title'],
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          Icon(Icons.arrow_forward_ios,
                              size: 14, color: Colors.grey[400]),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}