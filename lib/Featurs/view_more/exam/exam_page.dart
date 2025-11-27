// import 'package:flutter/material.dart';

// class ExamPage extends StatefulWidget {
//   const ExamPage({Key? key}) : super(key: key);

//   @override
//   State<ExamPage> createState() => _ExamPageState();
// }

// class _ExamPageState extends State<ExamPage> with SingleTickerProviderStateMixin {
//   late TabController _tabController;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Exams'),
//         backgroundColor: const Color(0xFF283593),
//         foregroundColor: Colors.white,
//         elevation: 0,
//         bottom: TabBar(
//           controller: _tabController,
//           indicatorColor: Colors.white,
//           indicatorWeight: 3,
//           labelColor: Colors.white,
//           unselectedLabelColor: Colors.white70,
//           tabs: const [
//             Tab(icon: Icon(Icons.calendar_today_rounded), text: 'Time Table'),
//             Tab(icon: Icon(Icons.event_seat_rounded), text: 'Seat Arrangement'),
//           ],
//         ),
//       ),
//       body: TabBarView(
//         controller: _tabController,
//         children: const [
//           ExamTimeTableTab(),
//           SeatArrangementTab(),
//         ],
//       ),
//     );
//   }
// }

// // Time Table Tab
// class ExamTimeTableTab extends StatelessWidget {
//   const ExamTimeTableTab({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final List<Map<String, dynamic>> examSchedule = [
//       {
//         'subject': 'Mathematics',
//         'code': 'MATH101',
//         'date': '2025-11-20',
//         'time': '09:00 AM - 12:00 PM',
//         'duration': '3 hours',
//         'hall': 'Main Hall A'
//       },
//       {
//         'subject': 'Physics',
//         'code': 'PHY201',
//         'date': '2025-11-22',
//         'time': '02:00 PM - 05:00 PM',
//         'duration': '3 hours',
//         'hall': 'Science Block B'
//       },
//       {
//         'subject': 'Chemistry',
//         'code': 'CHEM201',
//         'date': '2025-11-25',
//         'time': '09:00 AM - 12:00 PM',
//         'duration': '3 hours',
//         'hall': 'Main Hall C'
//       },
//       {
//         'subject': 'Computer Science',
//         'code': 'CS301',
//         'date': '2025-11-27',
//         'time': '02:00 PM - 05:00 PM',
//         'duration': '3 hours',
//         'hall': 'IT Lab 1'
//       },
//       {
//         'subject': 'English',
//         'code': 'ENG101',
//         'date': '2025-11-29',
//         'time': '09:00 AM - 12:00 PM',
//         'duration': '3 hours',
//         'hall': 'Main Hall A'
//       },
//     ];

//     return ListView.builder(
//       padding: const EdgeInsets.all(16),
//       itemCount: examSchedule.length,
//       itemBuilder: (context, index) {
//         final exam = examSchedule[index];
//         return Card(
//           elevation: 4,
//           margin: const EdgeInsets.only(bottom: 16),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFF283593).withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: const Icon(
//                         Icons.school_rounded,
//                         color: Color(0xFF283593),
//                         size: 28,
//                       ),
//                     ),
//                     const SizedBox(width: 16),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             exam['subject'],
//                             style: const TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                               color: Color(0xFF283593),
//                             ),
//                           ),
//                           Text(
//                             exam['code'],
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: Colors.grey[600],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//                 const Divider(),
//                 const SizedBox(height: 12),
//                 _buildInfoRow(Icons.calendar_month, 'Date', exam['date']),
//                 const SizedBox(height: 8),
//                 _buildInfoRow(Icons.access_time, 'Time', exam['time']),
//                 const SizedBox(height: 8),
//                 _buildInfoRow(Icons.timer_outlined, 'Duration', exam['duration']),
//                 const SizedBox(height: 8),
//                 _buildInfoRow(Icons.location_on_outlined, 'Hall', exam['hall']),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildInfoRow(IconData icon, String label, String value) {
//     return Row(
//       children: [
//         Icon(icon, size: 20, color: Colors.grey[700]),
//         const SizedBox(width: 12),
//         Text(
//           '$label: ',
//           style: const TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w600,
//             color: Colors.black87,
//           ),
//         ),
//         Expanded(
//           child: Text(
//             value,
//             style: TextStyle(
//               fontSize: 14,
//               color: Colors.grey[700],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// // Seat Arrangement Tab
// class SeatArrangementTab extends StatelessWidget {
//   const SeatArrangementTab({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final List<Map<String, dynamic>> seatInfo = [
//       {
//         'subject': 'Mathematics',
//         'code': 'MATH101',
//         'date': '2025-11-20',
//         'hall': 'Main Hall A',
//         'block': 'Block 1',
//         'row': 'Row 5',
//         'seat': 'Seat 12',
//         'rollNo': 'CS2025001'
//       },
//       {
//         'subject': 'Physics',
//         'code': 'PHY201',
//         'date': '2025-11-22',
//         'hall': 'Science Block B',
//         'block': 'Block 2',
//         'row': 'Row 3',
//         'seat': 'Seat 8',
//         'rollNo': 'CS2025001'
//       },
//       {
//         'subject': 'Chemistry',
//         'code': 'CHEM201',
//         'date': '2025-11-25',
//         'hall': 'Main Hall C',
//         'block': 'Block 1',
//         'row': 'Row 7',
//         'seat': 'Seat 15',
//         'rollNo': 'CS2025001'
//       },
//       {
//         'subject': 'Computer Science',
//         'code': 'CS301',
//         'date': '2025-11-27',
//         'hall': 'IT Lab 1',
//         'block': 'Lab Section A',
//         'row': 'Row 2',
//         'seat': 'System 6',
//         'rollNo': 'CS2025001'
//       },
//       {
//         'subject': 'English',
//         'code': 'ENG101',
//         'date': '2025-11-29',
//         'hall': 'Main Hall A',
//         'block': 'Block 3',
//         'row': 'Row 4',
//         'seat': 'Seat 10',
//         'rollNo': 'CS2025001'
//       },
//     ];

//     return ListView.builder(
//       padding: const EdgeInsets.all(16),
//       itemCount: seatInfo.length,
//       itemBuilder: (context, index) {
//         final seat = seatInfo[index];
//         return Card(
//           elevation: 4,
//           margin: const EdgeInsets.only(bottom: 16),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           child: Column(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF283593),
//                   borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(16),
//                     topRight: Radius.circular(16),
//                   ),
//                 ),
//                 child: Row(
//                   children: [
//                     const Icon(
//                       Icons.event_seat_rounded,
//                       color: Colors.white,
//                       size: 28,
//                     ),
//                     const SizedBox(width: 16),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             seat['subject'],
//                             style: const TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                           ),
//                           Text(
//                             seat['code'],
//                             style: const TextStyle(
//                               fontSize: 14,
//                               color: Colors.white70,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   children: [
//                     Row(
//                       children: [
//                         Expanded(
//                           child: _buildSeatDetail(
//                             Icons.calendar_today,
//                             'Date',
//                             seat['date'],
//                           ),
//                         ),
//                         Expanded(
//                           child: _buildSeatDetail(
//                             Icons.badge_outlined,
//                             'Roll No',
//                             seat['rollNo'],
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 16),
//                     _buildLocationCard(seat),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildSeatDetail(IconData icon, String label, String value) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Icon(icon, size: 18, color: Colors.grey[600]),
//             const SizedBox(width: 8),
//             Text(
//               label,
//               style: TextStyle(
//                 fontSize: 12,
//                 color: Colors.grey[600],
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 4),
//         Text(
//           value,
//           style: const TextStyle(
//             fontSize: 15,
//             fontWeight: FontWeight.w600,
//             color: Colors.black87,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildLocationCard(Map<String, dynamic> seat) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.blue[50],
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.blue[200]!),
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Icon(Icons.location_on, color: Colors.blue[700], size: 20),
//               const SizedBox(width: 8),
//               Text(
//                 'Seat Location',
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.blue[900],
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               _buildLocationPill(seat['hall']),
//               _buildLocationPill(seat['block']),
//             ],
//           ),
//           const SizedBox(height: 8),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               _buildLocationPill(seat['row']),
//               _buildLocationPill(seat['seat']),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildLocationPill(String text) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: Colors.blue[300]!),
//       ),
//       child: Text(
//         text,
//         style: TextStyle(
//           fontSize: 13,
//           fontWeight: FontWeight.w600,
//           color: Colors.blue[900],
//         ),
//       ),
//     );
//   }
// }
// Enhanced Time Table View Page with better image viewing
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TimeTableViewPage extends StatelessWidget {
  const TimeTableViewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exam Time Table'),
        backgroundColor: const Color(0xFF283593),
        foregroundColor: Colors.white,
      ),
      body: _TimeTableViewContent(),
    );
  }
}

class _TimeTableViewContent extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('timetables').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _buildErrorWidget('Error loading timetable');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingWidget();
        }

        final timetables = snapshot.data!.docs;

        if (timetables.isEmpty) {
          return _buildEmptyWidget(
            icon: Icons.calendar_today,
            message: 'No timetable available',
            subMessage: 'Please check back later',
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: timetables.length,
          itemBuilder: (context, index) {
            final timetable = timetables[index];
            final data = timetable.data() as Map<String, dynamic>;
            return _buildTimetableCard(data, context);
          },
        );
      },
    );
  }

  Widget _buildTimetableCard(Map<String, dynamic> data, BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with zoom capability
          _buildImageSection(
            context: context,
            imageUrl: data['imageUrl'],
            title: data['title'] ?? 'Time Table',
            heroTag: 'timetable_${data['title']}',
          ),
          
          // Info section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['title'] ?? 'Exam Time Table',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 6),
                    Text(
                      'Uploaded: ${_formatTimestamp(data['createdAt'])}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection({
    required BuildContext context,
    required String? imageUrl,
    required String title,
    required String heroTag,
  }) {
    if (imageUrl == null) {
      return _buildPlaceholderSection(
        icon: Icons.calendar_today,
        title: 'No Image Available',
      );
    }

    return Hero(
      tag: heroTag,
      child: Material(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        child: InkWell(
          onTap: () => _showEnhancedImageViewer(
            context: context,
            imageUrl: imageUrl,
            title: title,
            heroTag: heroTag,
          ),
          child: Stack(
            children: [
              Container(
                height: 220,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return _buildImageLoading();
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return _buildImageError();
                    },
                  ),
                ),
              ),
              Positioned(
                bottom: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.zoom_in, size: 14, color: Colors.white),
                      SizedBox(width: 4),
                      Text(
                        'Tap to view',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEnhancedImageViewer({
    required BuildContext context,
    required String imageUrl,
    required String title,
    required String heroTag,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.download),
                onPressed: () {
                  // Add download functionality here
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Download feature coming soon'),
                    ),
                  );
                },
              ),
            ],
          ),
          body: Center(
            child: InteractiveViewer(
              panEnabled: true,
              minScale: 0.5,
              maxScale: 4.0,
              child: Hero(
                tag: heroTag,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return _buildImageLoading();
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return _buildImageError();
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Enhanced Seat Arrangement View Page
class SeatArrangementViewPage extends StatelessWidget {
  const SeatArrangementViewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seat Arrangements'),
        backgroundColor: const Color(0xFF283593),
        foregroundColor: Colors.white,
      ),
      body: _SeatArrangementViewContent(),
    );
  }
}

class _SeatArrangementViewContent extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('seat_arrangements').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _buildErrorWidget('Error loading seat arrangements');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingWidget();
        }

        final arrangements = snapshot.data!.docs;

        if (arrangements.isEmpty) {
          return _buildEmptyWidget(
            icon: Icons.event_seat,
            message: 'No seat arrangements available',
            subMessage: 'Please check back later',
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: arrangements.length,
          itemBuilder: (context, index) {
            final arrangement = arrangements[index];
            final data = arrangement.data() as Map<String, dynamic>;
            return _buildSeatArrangementCard(data, context);
          },
        );
      },
    );
  }

  Widget _buildSeatArrangementCard(Map<String, dynamic> data, BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImageSection(
            context: context,
            imageUrl: data['imageUrl'],
            title: data['title'] ?? 'Seat Arrangement',
            heroTag: 'seat_${data['title']}',
          ),
          
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['title'] ?? 'Seat Arrangement',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 6),
                    Text(
                      'Uploaded: ${_formatTimestamp(data['createdAt'])}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Reuse the same image section widget from TimeTable
  Widget _buildImageSection({
    required BuildContext context,
    required String? imageUrl,
    required String title,
    required String heroTag,
  }) {
    if (imageUrl == null) {
      return _buildPlaceholderSection(
        icon: Icons.event_seat,
        title: 'No Image Available',
      );
    }

    return Hero(
      tag: heroTag,
      child: Material(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        child: InkWell(
          onTap: () => _showEnhancedImageViewer(
            context: context,
            imageUrl: imageUrl,
            title: title,
            heroTag: heroTag,
          ),
          child: Stack(
            children: [
              Container(
                height: 220,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return _buildImageLoading();
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return _buildImageError();
                    },
                  ),
                ),
              ),
              Positioned(
                bottom: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.zoom_in, size: 14, color: Colors.white),
                      SizedBox(width: 4),
                      Text(
                        'Tap to view',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEnhancedImageViewer({
    required BuildContext context,
    required String imageUrl,
    required String title,
    required String heroTag,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.download),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Download feature coming soon'),
                    ),
                  );
                },
              ),
            ],
          ),
          body: Center(
            child: InteractiveViewer(
              panEnabled: true,
              minScale: 0.5,
              maxScale: 4.0,
              child: Hero(
                tag: heroTag,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return _buildImageLoading();
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return _buildImageError();
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Common helper widgets
Widget _buildErrorWidget(String message) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
        const SizedBox(height: 16),
        Text(
          message,
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

Widget _buildLoadingWidget() {
  return const Center(child: CircularProgressIndicator());
}

Widget _buildEmptyWidget({
  required IconData icon,
  required String message,
  required String subMessage,
}) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 64, color: Colors.grey[400]),
        const SizedBox(height: 16),
        Text(
          message,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          subMessage,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

Widget _buildPlaceholderSection({required IconData icon, required String title}) {
  return Container(
    height: 150,
    width: double.infinity,
    decoration: BoxDecoration(
      color: Colors.grey[100],
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 48, color: Colors.grey[400]),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(color: Colors.grey[600]),
        ),
      ],
    ),
  );
}

Widget _buildImageLoading() {
  return Container(
    height: 220,
    color: Colors.grey[200],
    child: const Center(
      child: CircularProgressIndicator(),
    ),
  );
}

Widget _buildImageError() {
  return Container(
    height: 220,
    color: Colors.grey[200],
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.broken_image, size: 48, color: Colors.grey[400]),
        const SizedBox(height: 8),
        Text(
          'Failed to load image',
          style: TextStyle(color: Colors.grey[600]),
        ),
      ],
    ),
  );
}

String _formatTimestamp(dynamic timestamp) {
  if (timestamp == null) return 'Unknown date';
  if (timestamp is Timestamp) {
    final date = timestamp.toDate();
    return '${date.day}/${date.month}/${date.year}';
  }
  return 'Unknown date';
}