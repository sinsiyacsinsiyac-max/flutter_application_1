// // ChatbotHomePage.dart (fixed: removed listModels, added ping test)
// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/Featurs/view_more/seemore_page.dart';

// // void main() {
// //   runApp(const CampusAssistantApp());
// // }

// // class CampusAssistantApp extends StatelessWidget {
// //   const CampusAssistantApp({Key? key}) : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Campus Assistant',
// //       debugShowCheckedModeBanner: false,
// //       theme: ThemeData(
// //         primarySwatch: Colors.indigo,
// //         fontFamily: 'SF Pro Display',
// //       ),
// //       home: const ChatbotHomePage(),
// //     );
// //   }
// // }

// class ChatbotHomePage extends StatefulWidget {
//   const ChatbotHomePage({Key? key}) : super(key: key);

//   @override
//   State<ChatbotHomePage> createState() => _ChatbotHomePageState();
// }

// class _ChatbotHomePageState extends State<ChatbotHomePage>
//     with TickerProviderStateMixin {
//   final TextEditingController _messageController = TextEditingController();
//   late AnimationController _pulseController;
//   late AnimationController _floatController;

//   @override
//   void initState() {
//     super.initState();
//     _pulseController = AnimationController(
//       duration: const Duration(seconds: 3),
//       vsync: this,
//     )..repeat(reverse: true);

//     _floatController = AnimationController(
//       duration: const Duration(seconds: 8),
//       vsync: this,
//     )..repeat(reverse: true);
//   }

//   @override
//   void dispose() {
//     _messageController.dispose();
//     _pulseController.dispose();
//     _floatController.dispose();
//     super.dispose();
//   }

//   void _handleSend() {
//     if (_messageController.text.trim().isNotEmpty) {
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: const Text('Message Sent'),
//           content: Text('You said: ${_messageController.text}'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('OK'),
//             ),
//           ],
//         ),
//       );
//       _messageController.clear();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [
//               Color.fromARGB(255, 14, 122, 245),
//               Color.fromARGB(255, 92, 128, 246),
//               Colors.white,
//             ],
//           ),
//         ),
//         child: Stack(
//           children: [
//             // Floating orbs
//             AnimatedBuilder(
//               animation: _floatController,
//               builder: (context, child) {
//                 return Positioned(
//                   top: -200 + (_floatController.value * 60),
//                   right: -200 + (_floatController.value * 60),
//                   child: Container(
//                     width: 500,
//                     height: 500,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       gradient: RadialGradient(
//                         colors: [
//                           Colors.white.withOpacity(0.1),
//                           Colors.transparent,
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//             AnimatedBuilder(
//               animation: _floatController,
//               builder: (context, child) {
//                 return Positioned(
//                   bottom: -150 - (_floatController.value * 60),
//                   left: -150 - (_floatController.value * 60),
//                   child: Container(
//                     width: 400,
//                     height: 400,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       gradient: RadialGradient(
//                         colors: [
//                           Colors.white.withOpacity(0.08),
//                           Colors.transparent,
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//             // Main content
//             SafeArea(
//               child: Column(
//                 children: [
//                   Expanded(
//                     child: Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           // Icon with pulse animation
//                           AnimatedBuilder(
//                             animation: _pulseController,
//                             builder: (context, child) {
//                               return Transform.scale(
//                                 scale: 1.0 + (_pulseController.value * 0.05),
//                                 child: Container(
//                                   width: 100,
//                                   height: 100,
//                                   decoration: BoxDecoration(
//                                     color: Colors.white.withOpacity(0.15),
//                                     borderRadius: BorderRadius.circular(30),
//                                     border: Border.all(
//                                       color: Colors.white.withOpacity(0.3),
//                                       width: 2,
//                                     ),
//                                     boxShadow: [
//                                       BoxShadow(
//                                         color: Colors.black.withOpacity(0.2),
//                                         blurRadius: 60,
//                                         spreadRadius: 10,
//                                       ),
//                                     ],
//                                   ),
//                                   child: const Center(
//                                     child: Text(
//                                       '🎓',
//                                       style: TextStyle(fontSize: 50),
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                           const SizedBox(height: 30),
//                           // Title
//                           const Text(
//                             'Campus Assistant',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 52,
//                               fontWeight: FontWeight.w800,
//                               letterSpacing: -1,
//                               shadows: [
//                                 Shadow(
//                                   color: Colors.black26,
//                                   blurRadius: 20,
//                                   offset: Offset(0, 4),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(height: 20),
//                           // Subtitle
//                           Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 40),
//                             child: Text(
//                               'Hi! I am your Campus Assistant. How can I help you?',
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                 color: Colors.white.withOpacity(0.95),
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.w400,
//                                 height: 1.6,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   // Input bar at bottom
//                   Container(
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         begin: Alignment.bottomCenter,
//                         end: Alignment.topCenter,
//                         colors: [
//                           const Color(0xFF6366F1).withOpacity(0.3),
//                           Colors.transparent,
//                         ],
//                       ),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(20.0),
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: Colors.white.withOpacity(0.95),
//                           borderRadius: BorderRadius.circular(30),
//                           border: Border.all(
//                             color: Colors.white.withOpacity(0.5),
//                             width: 2,
//                           ),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.3),
//                               blurRadius: 80,
//                               spreadRadius: 10,
//                             ),
//                           ],
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(10.0),
//                           child: Row(
//                             children: [
//                               Expanded(
//                                 child: TextField(
//                                   controller: _messageController,
//                                   decoration: const InputDecoration(
//                                     hintText: 'Type your message here...',
//                                     hintStyle: TextStyle(
//                                       color: Colors.grey,
//                                       fontWeight: FontWeight.w400,
//                                     ),
//                                     border: InputBorder.none,
//                                     contentPadding: EdgeInsets.symmetric(
//                                       horizontal: 24,
//                                       vertical: 18,
//                                     ),
//                                   ),
//                                   style: const TextStyle(
//                                     fontSize: 17,
//                                     fontWeight: FontWeight.w500,
//                                     color: Color(0xFF1A1A1A),
//                                   ),
//                                   onSubmitted: (_) => _handleSend(),
//                                 ),
//                               ),
//                               const SizedBox(width: 12),
//                               GestureDetector(
//                                 onTap: _handleSend,
//                                 child: Container(
//                                   width: 56,
//                                   height: 56,
//                                   decoration: BoxDecoration(
//                                     shape: BoxShape.circle,
//                                     gradient: const LinearGradient(
//                                       begin: Alignment.topLeft,
//                                       end: Alignment.bottomRight,
//                                       colors: [
//                                         Color(0xFF6366F1),
//                                         Color(0xFF8B5CF6),
//                                       ],
//                                     ),
//                                     boxShadow: [
//                                       BoxShadow(
//                                         color: const Color(
//                                           0xFF6366F1,
//                                         ).withOpacity(0.4),
//                                         blurRadius: 20,
//                                         spreadRadius: 2,
//                                       ),
//                                     ],
//                                   ),
//                                   child: const Center(
//                                     child: Text(
//                                       '↑',
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 24,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Positioned(
//               right: 20,
//               top: 50,
//               child: GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => ExpantioList()),
//                   );
//                 },
//                 child: Text('view more', style: TextStyle(color: Colors.white)),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/Featurs/view_more/seemore_page.dart';

class ChatbotHomePage extends StatefulWidget {
  const ChatbotHomePage({Key? key}) : super(key: key);

  @override
  State<ChatbotHomePage> createState() => _ChatbotHomePageState();
}

class _ChatbotHomePageState extends State<ChatbotHomePage>
    with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  late AnimationController _pulseController;
  late AnimationController _floatController;
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _allCourses = [];
  List<Map<String, dynamic>> _allAmenities = [];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _floatController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat(reverse: true);

    // Preload data for better matching
    _preloadData();

    // Print initial message
    _printToTerminal("🤖", "Campus Assistant started and ready!");
    _printToTerminal("🤖", "Welcome message sent to user");

    // Add welcome message
    _addBotMessage(
      "Hello! 👋 I'm your Campus Assistant. I can help you find information about:\n\n"
      "📚 Courses & Subjects\n"
      "🏛️ Campus Amenities\n"
      "📅 Events & Schedules\n"
      "📖 Study Materials\n\n"
      "What would you like to know?",
    );
  }

  // Preload data for better matching
  Future<void> _preloadData() async {
    try {
      final courses = await _firestore.collection('courses').get();
      final amenities = await _firestore.collection('amenities').get();

      setState(() {
        _allCourses = courses.docs.map((doc) => doc.data()).toList();
        _allAmenities = amenities.docs.map((doc) => doc.data()).toList();
      });

      _printToTerminal(
        "📦",
        "Preloaded ${_allCourses.length} courses and ${_allAmenities.length} amenities",
      );
    } catch (e) {
      _printToTerminal("❌", "Failed to preload data: $e");
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _pulseController.dispose();
    _floatController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Terminal logging function
  void _printToTerminal(String sender, String message) {
    final timestamp = DateTime.now().toIso8601String();
    final separator = "=" * 80;

    print("\n$separator");
    print("🕐 TIMESTAMP: $timestamp");
    print("👤 SENDER: $sender");
    print("💬 MESSAGE:");
    print(message);
    print("$separator\n");
  }

  void _addUserMessage(String text) {
    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
    });

    // Log user question to terminal
    _printToTerminal("👤 USER", text);

    _scrollToBottom();
  }

  void _addBotMessage(String text) {
    setState(() {
      _messages.add(ChatMessage(text: text, isUser: false));
    });

    // Log bot answer to terminal
    _printToTerminal("🤖 BOT", text);

    _scrollToBottom();
  }

  // Enhanced keyword detection
  List<String> _extractKeywords(String query) {
    final queryLower = query.toLowerCase();
    final words = queryLower.split(' ');

    // Extended keyword list for better matching
    final extendedKeywords = [
      'course',
      'subject',
      'class',
      'credit',
      'fee',
      'fees',
      'tuition',
      'cost',
      'price',
      'amenity',
      'facility',
      'library',
      'canteen',
      'auditorium',
      'lab',
      'sport',
      'gym',
      'event',
      'upcoming',
      'schedule',
      'calendar',
      'study',
      'material',
      'notes',
      'book',
      'resource',
      'help',
      'what',
      'how',
      'when',
      'where',
    ];

    return extendedKeywords
        .where((keyword) => queryLower.contains(keyword))
        .toList();
  }

  // Improved course name detection
  String? _detectCourseName(String query) {
    final queryLower = query.toLowerCase();

    for (var course in _allCourses) {
      final courseName = course['name']?.toString().toLowerCase() ?? '';
      final courseCode = course['code']?.toString().toLowerCase() ?? '';

      if (courseName.isNotEmpty && queryLower.contains(courseName)) {
        _printToTerminal("🎯", "Detected course by name: $courseName");
        return course['name'];
      }

      if (courseCode.isNotEmpty && queryLower.contains(courseCode)) {
        _printToTerminal("🎯", "Detected course by code: $courseCode");
        return course['name'];
      }

      // Check for partial matches (like "bca" in "fees for bca")
      if (courseName.length > 3) {
        final shortName = courseName
            .split(' ')
            .last; // Get last word of course name
        if (shortName.isNotEmpty && queryLower.contains(shortName)) {
          _printToTerminal(
            "🎯",
            "Detected course by partial name: $shortName -> $courseName",
          );
          return course['name'];
        }
      }
    }

    return null;
  }

  // Smart response generator using Firestore data
  Future<void> _handleSend() async {
    final userMessage = _messageController.text.trim();
    if (userMessage.isEmpty) return;

    _addUserMessage(userMessage);
    _messageController.clear();

    setState(() {
      _isLoading = true;
    });

    _scrollToBottom();

    // Log processing start
    _printToTerminal("⚙️", "Processing user query: '$userMessage'");

    try {
      final response = await _generateSmartResponse(userMessage);
      _addBotMessage(response);

      // Log processing completion
      _printToTerminal(
        "✅",
        "Response generated successfully for: '$userMessage'",
      );
    } catch (e) {
      final errorMessage =
          "I encountered an issue. Please try again in a moment.";
      _addBotMessage(errorMessage);

      // Log error
      _printToTerminal("❌ ERROR", "Error processing '$userMessage': $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Enhanced smart response generator
  Future<String> _generateSmartResponse(String query) async {
    final queryLower = query.toLowerCase();
    final keywords = _extractKeywords(queryLower);
    final detectedCourse = _detectCourseName(query);

    // Log query analysis
    _printToTerminal("🔍", "Analyzing query: '$query'");
    _printToTerminal("🔍", "Query keywords detected: $keywords");
    if (detectedCourse != null) {
      _printToTerminal("🔍", "Detected course: $detectedCourse");
    }

    // Greetings
    if (_isGreeting(queryLower)) {
      _printToTerminal("🎯", "Query classified as: GREETING");
      return "Hello! 👋 Nice to meet you! I'm here to help you with campus information. What would you like to know about?";
    }

    // Courses information - expanded to include fee-related queries and course names
    bool isCourseQuery =
        queryLower.contains('course') ||
        queryLower.contains('subject') ||
        queryLower.contains('class') ||
        queryLower.contains('credit') ||
        queryLower.contains('fee') ||
        queryLower.contains('fees') ||
        queryLower.contains('tuition') ||
        queryLower.contains('cost') ||
        queryLower.contains('price') ||
        detectedCourse != null;

    if (isCourseQuery) {
      _printToTerminal("🎯", "Query classified as: COURSES");
      return await _getCoursesResponse(queryLower, detectedCourse);
    }

    // Amenities information
    if (queryLower.contains('amenity') ||
        queryLower.contains('facility') ||
        queryLower.contains('library') ||
        queryLower.contains('canteen') ||
        queryLower.contains('auditorium') ||
        queryLower.contains('lab')) {
      _printToTerminal("🎯", "Query classified as: AMENITIES");
      return await _getAmenitiesResponse(queryLower);
    }

    // Events information
    if (queryLower.contains('event') ||
        queryLower.contains('upcoming') ||
        queryLower.contains('schedule')) {
      _printToTerminal("🎯", "Query classified as: EVENTS");
      return await _getEventsResponse();
    }

    // Study materials
    if (queryLower.contains('study') ||
        queryLower.contains('material') ||
        queryLower.contains('notes') ||
        queryLower.contains('book')) {
      _printToTerminal("🎯", "Query classified as: STUDY MATERIALS");
      return await _getStudyMaterialsResponse();
    }

    // Help
    if (queryLower.contains('help') || queryLower.contains('what can you do')) {
      _printToTerminal("🎯", "Query classified as: HELP");
      return _getHelpResponse();
    }

    // Default response for unknown queries
    _printToTerminal("🎯", "Query classified as: UNKNOWN/OTHER");
    return """
I'm not sure I understand. Here's what I can help you with:

📚 **Course Information**
• Course details, credits, schedules, fees
• Department information
• Teacher assignments

🏛️ **Campus Facilities**
• Library timings and capacity
• Auditorium availability
• Sports facilities, Labs, Canteen

📅 **Events & Activities**
• Upcoming college events
• Workshop schedules
• Cultural activities

📖 **Study Resources**
• Study materials availability
• Notes and books location

Try asking about specific courses like "BCA fees" or "Computer Science courses"!""";
  }

  bool _isGreeting(String query) {
    return query.contains('hi') ||
        query.contains('hello') ||
        query.contains('hey') ||
        query.contains('good morning') ||
        query.contains('good afternoon');
  }

  Future<String> _getCoursesResponse(
    String query,
    String? specificCourse,
  ) async {
    try {
      _printToTerminal("📚", "Fetching courses data from Firestore...");

      final courses = await _firestore.collection('courses').limit(20).get();

      _printToTerminal(
        "📚",
        "Found ${courses.docs.length} courses in database",
      );

      if (courses.docs.isEmpty) {
        _printToTerminal("📚", "No courses found in database");
        return "I don't see any courses in the database yet. Please contact administration to add course information.";
      }

      // If specific course is detected or query contains fee information
      if (specificCourse != null ||
          query.contains('fee') ||
          query.contains('fees')) {
        String? targetCourse = specificCourse;

        // If no specific course detected but fee query, try to find the most relevant course
        if (targetCourse == null) {
          for (var doc in courses.docs) {
            final courseName =
                doc.data()['name']?.toString().toLowerCase() ?? '';
            if (query.contains(courseName) && courseName.isNotEmpty) {
              targetCourse = doc.data()['name'];
              _printToTerminal(
                "📚",
                "Found course for fee query: $targetCourse",
              );
              break;
            }
          }
        }

        if (targetCourse != null) {
          // Show specific course details
          for (var doc in courses.docs) {
            final data = doc.data();
            if (data['name']?.toString().toLowerCase() ==
                targetCourse!.toLowerCase()) {
              _printToTerminal(
                "📚",
                "Displaying detailed info for: $targetCourse",
              );

              // Build detailed response with all available information
              String response =
                  """
📘 **${data['name'] ?? 'Course'} Details**

• **Course Code:** ${data['code'] ?? 'N/A'}
• **Department:** ${data['department'] ?? 'N/A'}""";

              // Add credits if available
              if (data['credits'] != null) {
                response += "\n• **Credits:** ${data['credits']}";
              }

              // Add semester if available
              if (data['semester'] != null) {
                response += "\n• **Semester:** ${data['semester']}";
              }

              // Add teacher if available

              // Add student information if available
              if (data['maxStudents'] != null) {
                response += "\n• **Max Students:** ${data['maxStudents']}";
              }

              if (data['enrolledStudents'] != null) {
                response +=
                    "\n• **Currently Enrolled:** ${data['enrolledStudents']}";
              }

              // Add fee information - check multiple possible field names
              final semesterFees =
                  data['semesterFees'] ??
                  data['fees'] ??
                  data['fee'] ??
                  data['tuition'];
              if (semesterFees != null) {
                response += "\n• **Semester Fees:** ₹$semesterFees";
              } else {
                response += "\n• **Semester Fees:** Information not available";
              }

              // Add description if available
              if (data['description'] != null) {
                response += "\n\n**Description:** ${data['description']}";
              } else {
                response += "\n\nNo additional description available.";
              }

              return response;
            }
          }
        }
      }

      // Show all courses summary
      String response = "📚 **Available Courses:**\n\n";

      for (var i = 0; i < courses.docs.length && i < 8; i++) {
        final data = courses.docs[i].data();
        final courseName = data['name'] ?? 'Course';
        final courseCode = data['code'] ?? 'Code';
        final department = data['department'] ?? 'Dept';

        response += "• $courseName ($courseCode) - $department";

        // Add fee information if available
        final fees = data['semesterFees'] ?? data['fees'];
        if (fees != null) {
          response += " - ₹$fees";
        }

        response += "\n";
      }

      if (courses.docs.length > 8) {
        response +=
            "\n... and ${courses.docs.length - 8} more courses available.";
      }

      response +=
          "\n\nAsk about a specific course for more details! (e.g., 'BCA fees' or 'Computer Science course details')";

      _printToTerminal(
        "📚",
        "Displaying courses summary (${courses.docs.length} total)",
      );
      return response;
    } catch (e) {
      _printToTerminal("❌ COURSES ERROR", "Firestore error: $e");
      return "I'm having trouble accessing course information right now. Please try again later or contact the administration.";
    }
  }

  Future<String> _getAmenitiesResponse(String query) async {
    try {
      _printToTerminal("🏛️", "Fetching amenities data from Firestore...");

      final amenities = await _firestore
          .collection('amenities')
          .limit(10)
          .get();

      _printToTerminal(
        "🏛️",
        "Found ${amenities.docs.length} amenities in database",
      );

      if (amenities.docs.isEmpty) {
        _printToTerminal("🏛️", "No amenities found in database");
        return "No amenity information is currently available. Please check back later.";
      }

      String response = "🏛️ **Campus Amenities:**\n\n";

      // Check for specific amenity
      for (var doc in amenities.docs) {
        final amenityName = doc.data()['name']?.toString().toLowerCase() ?? '';
        if (query.contains(amenityName) && amenityName.isNotEmpty) {
          final data = doc.data();
          _printToTerminal(
            "🏛️",
            "Specific amenity requested: ${data['name']}",
          );
          return """
🏛️ **${data['name'] ?? 'Amenity'} Information**

• **Category:** ${data['category'] ?? 'N/A'}
• **Location:** ${data['location'] ?? 'N/A'}
• **Capacity:** ${data['capacity'] ?? 'N/A'} people
• **Availability:** ${data['available'] == true ? '✅ Available' : '❌ Not Available'}
• **Timings:** ${data['timings'] ?? 'Not specified'}
${data['contact'] != null ? '• **Contact:** ${data['contact']}\n' : ''}
${data['description'] ?? ''}""";
        }
      }

      // Show all amenities
      for (var i = 0; i < amenities.docs.length && i < 5; i++) {
        final data = amenities.docs[i].data();
        final status = data['available'] == true ? '✅' : '❌';
        response +=
            "$status ${data['name'] ?? 'Amenity'} - ${data['location'] ?? 'Location'}\n";
      }

      if (amenities.docs.length > 5) {
        response += "\n... and ${amenities.docs.length - 5} more amenities.";
      }

      _printToTerminal(
        "🏛️",
        "Displaying amenities summary (${amenities.docs.length} total)",
      );
      return response;
    } catch (e) {
      _printToTerminal("❌ AMENITIES ERROR", "Firestore error: $e");
      return "I can't access amenity information at the moment. Please try again later.";
    }
  }

  Future<String> _getEventsResponse() async {
    try {
      _printToTerminal("📅", "Fetching events data from Firestore...");

      final events = await _firestore.collection('events').limit(5).get();

      _printToTerminal("📅", "Found ${events.docs.length} events in database");

      if (events.docs.isEmpty) {
        _printToTerminal("📅", "No events found in database");
        return "No upcoming events are scheduled at the moment. Please check the notice board or contact student affairs for updates.";
      }

      String response = "📅 **Upcoming Events:**\n\n";

      for (var doc in events.docs) {
        final data = doc.data();
        response += "🎯 **${data['name'] ?? 'Event'}**\n";
        response += "   📅 ${data['date'] ?? 'Date not specified'}\n";
        response += "   📍 ${data['location'] ?? 'Location not specified'}\n";
        if (data['description'] != null) {
          response += "   📝 ${data['description']}\n";
        }
        response += "\n";
      }

      _printToTerminal("📅", "Displaying ${events.docs.length} events");
      return response;
    } catch (e) {
      _printToTerminal("❌ EVENTS ERROR", "Firestore error: $e");
      return "Event information is currently unavailable. Please check the college notice board for updates.";
    }
  }

  Future<String> _getStudyMaterialsResponse() async {
    try {
      _printToTerminal("📖", "Fetching study materials data from Firestore...");

      final materials = await _firestore
          .collection('study_materials')
          .limit(5)
          .get();

      _printToTerminal(
        "📖",
        "Found ${materials.docs.length} study materials in database",
      );

      if (materials.docs.isEmpty) {
        _printToTerminal("📖", "No study materials found in database");
        return "No study materials are currently listed in the database. Please check with your department or library for available resources.";
      }

      String response = "📖 **Available Study Materials:**\n\n";

      for (var doc in materials.docs) {
        final data = doc.data();
        response += "• **${data['title'] ?? 'Material'}**\n";
        response += "  For: ${data['course'] ?? 'Various Courses'}\n";
        response += "  Type: ${data['type'] ?? 'Study Material'}\n\n";
      }

      _printToTerminal(
        "📖",
        "Displaying ${materials.docs.length} study materials",
      );
      return response;
    } catch (e) {
      _printToTerminal("❌ STUDY MATERIALS ERROR", "Firestore error: $e");
      return "Study material information is currently unavailable. Please visit the library or contact your department for resources.";
    }
  }

  String _getHelpResponse() {
    _printToTerminal("ℹ️", "Help information requested by user");
    return """
🤖 **Campus Assistant Help**

I can help you find information about:

📚 **COURSES**
• "Show me computer science courses"
• "What mathematics courses are available?"
• "Tell me about course credits"
• "BCA fees" or "fees for BCA course"

🏛️ **AMENITIES**
• "Library timings and capacity"
• "Available auditoriums"
• "Sports facilities"
• "Canteen location"

📅 **EVENTS**
• "Upcoming college events"
• "Workshop schedules"
• "Cultural activities"

📖 **STUDY MATERIALS**
• "Available study notes"
• "Course books location"
• "Study resources"

💡 **Tips:**
• Be specific for better results
• Ask about particular courses or facilities
• Use course names like "BCA", "economics", etc.
• Ask about fees for specific courses

What would you like to know?""";
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ExpantioList()),
                );
              },
              child: Icon(Icons.list),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 14, 122, 245),
              Color.fromARGB(255, 92, 128, 246),
              Colors.white,
            ],
          ),
        ),
        child: Stack(
          children: [
            // Floating orbs
            AnimatedBuilder(
              animation: _floatController,
              builder: (context, child) {
                return Positioned(
                  top: -200 + (_floatController.value * 60),
                  right: -200 + (_floatController.value * 60),
                  child: Container(
                    width: 500,
                    height: 500,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.white.withOpacity(0.1),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            AnimatedBuilder(
              animation: _floatController,
              builder: (context, child) {
                return Positioned(
                  bottom: -150 - (_floatController.value * 60),
                  left: -150 - (_floatController.value * 60),
                  child: Container(
                    width: 400,
                    height: 400,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.white.withOpacity(0.08),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

            // Main content
            SafeArea(
              child: Column(
                children: [
                  // Messages list or welcome screen
                  Expanded(
                    child: _messages.isEmpty
                        ? _buildWelcomeScreen()
                        : _buildChatList(),
                  ),
                  // Input bar at bottom
                  _buildInputBar(),
                ],
              ),
            ),

            // Enhanced View More Button
            // Positioned(right: 20, top: 50, child: _buildViewMoreButton()),
          ],
        ),
      ),
    );
  }

  // Decorated View More Button
  Widget _buildViewMoreButton() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withOpacity(0.4),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ExpantioList()),
            );
          },
          borderRadius: BorderRadius.circular(25),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.list, color: Colors.white, size: 18),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Simplified welcome screen without quick questions
  Widget _buildWelcomeScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon with pulse animation
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Transform.scale(
                scale: 1.0 + (_pulseController.value * 0.05),
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 60,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text('🎓', style: TextStyle(fontSize: 50)),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 30),
          // Title
          const Text(
            'Campus Assistant',
            style: TextStyle(
              color: Colors.white,
              fontSize: 52,
              fontWeight: FontWeight.w800,
              letterSpacing: -1,
              shadows: [
                Shadow(
                  color: Colors.black26,
                  blurRadius: 20,
                  offset: Offset(0, 4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Subtitle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Hi! I am your Campus Assistant. How can I help you?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.95),
                fontSize: 20,
                fontWeight: FontWeight.w400,
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(height: 40),
          // Simple instruction
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Type your question below to get started',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Chat list with only messages (no quick questions at top)
  Widget _buildChatList() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: _messages.length + (_isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _messages.length && _isLoading) {
                return _buildLoadingIndicator();
              }
              return _buildMessageBubble(_messages[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: message.isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser)
            Container(
              margin: const EdgeInsets.only(right: 8),
              child: CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.2),
                child: const Text('🎓', style: TextStyle(fontSize: 16)),
              ),
            ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: message.isUser ? const Color(0xFF6366F1) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: message.isUser ? Colors.white : Colors.black87,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          if (message.isUser)
            Container(
              margin: const EdgeInsets.only(left: 8),
              child: CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.2),
                child: const Icon(Icons.person, size: 16, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: CircleAvatar(
              backgroundColor: Colors.white.withOpacity(0.2),
              child: const Text('🎓', style: TextStyle(fontSize: 16)),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.blue.shade600,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  "Searching...",
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            const Color(0xFF6366F1).withOpacity(0.3),
            Colors.transparent,
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 80,
                spreadRadius: 10,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Ask me anything about campus...',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 18,
                      ),
                    ),
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1A1A1A),
                    ),
                    onSubmitted: (_) => _handleSend(),
                    enabled: !_isLoading,
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: _isLoading ? null : _handleSend,
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: _isLoading
                            ? [Colors.grey, Colors.grey.shade600]
                            : [
                                const Color(0xFF6366F1),
                                const Color(0xFF8B5CF6),
                              ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6366F1).withOpacity(0.4),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        '↑',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}
