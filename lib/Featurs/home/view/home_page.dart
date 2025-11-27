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
  Map<String, dynamic>? _collegeData;

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
      "📖 Study Materials\n"
      "🏫 College Contact Details\n\n"
      "What would you like to know?",
    );
  }

  // Preload data for better matching
  Future<void> _preloadData() async {
    try {
      final courses = await _firestore.collection('courses').get();
      final amenities = await _firestore.collection('amenities').get();
      final colleges = await _firestore.collection('colleges').limit(1).get();

      setState(() {
        _allCourses = courses.docs.map((doc) => doc.data()).toList();
        _allAmenities = amenities.docs.map((doc) => doc.data()).toList();
        if (colleges.docs.isNotEmpty) {
          _collegeData = colleges.docs.first.data();
        }
      });

      _printToTerminal(
        "📦",
        "Preloaded ${_allCourses.length} courses, ${_allAmenities.length} amenities, and college data",
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
      'college',
      'contact',
      'address',
      'phone',
      'email',
      'website',
      'office',
      'hours',
      'information',
      'details',
      'location',
      'where',
      'find',
      'locate',
    ];

    return extendedKeywords
        .where((keyword) => queryLower.contains(keyword))
        .toList();
  }

  // Check for exact course code match first
  String? _findExactCourseCodeMatch(String query) {
    final queryLower = query.toLowerCase().trim();

    for (var course in _allCourses) {
      final courseCode = course['code']?.toString().toLowerCase().trim() ?? '';
      final courseName = course['name']?.toString().toLowerCase().trim() ?? '';

      // Remove any non-alphanumeric characters for better matching
      final cleanQuery = queryLower.replaceAll(RegExp(r'[^a-z0-9]'), '');
      final cleanCourseCode = courseCode.replaceAll(RegExp(r'[^a-z0-9]'), '');

      if (cleanQuery == cleanCourseCode) {
        _printToTerminal(
          "🎯",
          "Exact course code match: $cleanQuery -> $courseName",
        );
        return course['name'];
      }
    }
    return null;
  }

  // Helper method for common abbreviations
  bool _isCommonAbbreviation(String query, String courseName) {
    final abbreviationMap = {
      'bca': 'bachelor of computer applications',
      'bcom': 'bachelor of commerce',
      'bsc': 'bachelor of science',
      'ba': 'bachelor of arts',
      'mca': 'master of computer applications',
    };

    final fullName = abbreviationMap[query];
    return fullName != null && courseName.contains(fullName);
  }

  // Improved course name detection with exact matching
  String? _detectCourseName(String query) {
    final queryLower = query.toLowerCase().trim();

    // Clean query - remove common filler words
    final cleanQuery = queryLower
        .replaceAll(RegExp(r'\b(for|about|the|course|details|fees|fee)\b'), '')
        .trim();

    _printToTerminal("🔍", "Cleaned query for course detection: '$cleanQuery'");

    for (var course in _allCourses) {
      final courseName = course['name']?.toString().toLowerCase().trim() ?? '';
      final courseCode = course['code']?.toString().toLowerCase().trim() ?? '';

      if (courseName.isEmpty) continue;

      // 1. Exact match with course name
      if (cleanQuery == courseName) {
        _printToTerminal("🎯", "Exact match found: $courseName");
        return course['name'];
      }

      // 2. Exact match with course code
      if (cleanQuery == courseCode) {
        _printToTerminal(
          "🎯",
          "Exact code match found: $courseCode -> $courseName",
        );
        return course['name'];
      }

      // 3. Query contains full course name
      if (cleanQuery.contains(courseName) && courseName.length > 2) {
        _printToTerminal("🎯", "Query contains full course name: $courseName");
        return course['name'];
      }

      // 4. Course name contains full query (for abbreviations)
      if (courseName.contains(cleanQuery) && cleanQuery.length > 2) {
        _printToTerminal(
          "🎯",
          "Course name contains query: $courseName contains $cleanQuery",
        );
        return course['name'];
      }

      // 5. Match individual words (for multi-word courses)
      final queryWords = cleanQuery.split(' ');
      final courseWords = courseName.split(' ');

      bool allWordsMatch = queryWords.every(
        (queryWord) =>
            queryWord.length > 2 &&
            courseWords.any((courseWord) => courseWord.contains(queryWord)),
      );

      if (allWordsMatch && queryWords.isNotEmpty) {
        _printToTerminal("🎯", "All words match for: $courseName");
        return course['name'];
      }

      // 6. Check for common abbreviations
      if (_isCommonAbbreviation(cleanQuery, courseName)) {
        _printToTerminal(
          "🎯",
          "Common abbreviation match: $cleanQuery -> $courseName",
        );
        return course['name'];
      }
    }

    _printToTerminal("❌", "No course match found for: '$cleanQuery'");
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

  // Enhanced smart response generator with better college contact detection
  Future<String> _generateSmartResponse(String query) async {
    final queryLower = query.toLowerCase();
    final keywords = _extractKeywords(queryLower);

    // Try exact course code match first
    final exactCodeMatch = _findExactCourseCodeMatch(query);
    final detectedCourse = exactCodeMatch ?? _detectCourseName(query);

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

    // College contact information - IMPROVED DETECTION
    bool isCollegeContactQuery = _isCollegeContactQuery(queryLower);
    if (isCollegeContactQuery) {
      _printToTerminal("🎯", "Query classified as: COLLEGE_CONTACT");
      return _getCollegeContactResponse();
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
        queryLower.contains('lab') ||
        queryLower.contains('sport') ||
        queryLower.contains('gym')) {
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

🏫 **College Information**
• Contact details, address, phone
• Email, website, office hours
• College location and directions

Try asking about specific courses like "BCA fees" or "college contact details"!""";
  }

  // Improved college contact query detection
  bool _isCollegeContactQuery(String queryLower) {
    // List of contact-related keywords that should trigger college contact response
    final contactKeywords = [
      'contact',
      'address',
      'phone',
      'telephone',
      'number',
      'email',
      'website',
      'web',
      'site',
      'office',
      'hours',
      'timing',
      'location',
      'where',
      'call',
      'email',
      'mail',
      'info',
      'information',
      'details',
      'find',
      'locate',
      'direction',
      'map',
    ];

    // List of college-related keywords (optional - makes it more specific)
    final collegeKeywords = [
      'college',
      'campus',
      'institute',
      'institution',
      'university',
      'school',
      'administration',
      'admin',
      'office',
    ];

    // Check if query contains contact-related keywords
    bool hasContactKeyword = contactKeywords.any(
      (keyword) => queryLower.contains(keyword),
    );

    // Check if query contains college-related keywords (optional for better context)
    bool hasCollegeKeyword = collegeKeywords.any(
      (keyword) => queryLower.contains(keyword),
    );

    // Special cases that should always trigger college contact
    bool isDirectContactQuery =
        queryLower == 'contact' ||
        queryLower == 'contact details' ||
        queryLower == 'contact info' ||
        queryLower == 'contact information' ||
        queryLower == 'college contact' ||
        queryLower == 'how to contact' ||
        queryLower == 'where is' ||
        queryLower == 'where is the college' ||
        queryLower == 'college location' ||
        queryLower == 'location' ||
        queryLower == 'address' ||
        queryLower == 'phone number' ||
        queryLower == 'email address';

    // Return true if:
    // 1. It's a direct contact query, OR
    // 2. Has contact keyword and college keyword, OR
    // 3. Has strong contact keywords even without college context
    // 4. Is specifically asking about location/address
    return isDirectContactQuery ||
        (hasContactKeyword && hasCollegeKeyword) ||
        (hasContactKeyword && _isStrongContactQuery(queryLower)) ||
        _isLocationQuery(queryLower);
  }

  // Check if it's a strong contact-related query
  bool _isStrongContactQuery(String queryLower) {
    final strongContactPatterns = [
      'contact details',
      'contact information',
      'phone number',
      'email address',
      'office hours',
      'where is',
      'how to contact',
      'get in touch',
      'reach us',
      'call us',
      'college location',
      'where is college',
      'find college',
      'locate college',
    ];

    return strongContactPatterns.any((pattern) => queryLower.contains(pattern));
  }

  // Check if it's a location query specifically for college
  bool _isLocationQuery(String queryLower) {
    final locationPatterns = [
      'location',
      'where is',
      'address',
      'find college',
      'locate college',
      'college location',
      'where is the college',
      'how to reach college',
      'college address',
      'college map',
      'directions to college',
    ];

    return locationPatterns.any((pattern) => queryLower.contains(pattern)) &&
        !queryLower.contains('library') &&
        !queryLower.contains('canteen') &&
        !queryLower.contains('auditorium') &&
        !queryLower.contains('lab') &&
        !queryLower.contains('sport') &&
        !queryLower.contains('gym') &&
        !queryLower.contains('amenity');
  }

  bool _isGreeting(String query) {
    return query.contains('hi') ||
        query.contains('hello') ||
        query.contains('hey') ||
        query.contains('good morning') ||
        query.contains('good afternoon');
  }

  // College contact information response
  String _getCollegeContactResponse() {
    if (_collegeData == null) {
      return "I'm sorry, but college contact information is currently unavailable. Please check the college notice board or visit the administration office for contact details.";
    }

    _printToTerminal("🏫", "Displaying college contact information");

    String response =
        """
🏫 **College Contact Information**

**College Name:** ${_collegeData!['name'] ?? 'Majlis Arts and Science College'}

**Contact Details:**
""";

    // Add phone if available
    if (_collegeData!['phone'] != null &&
        _collegeData!['phone'].toString().isNotEmpty) {
      response += "• 📞 **Phone:** ${_collegeData!['phone']}\n";
    } else {
      response += "• 📞 **Phone:** Not available\n";
    }

    // Add email if available
    if (_collegeData!['email'] != null &&
        _collegeData!['email'].toString().isNotEmpty) {
      response += "• 📧 **Email:** ${_collegeData!['email']}\n";
    } else {
      response += "• 📧 **Email:** Not available\n";
    }

    // Add website if available
    if (_collegeData!['website'] != null &&
        _collegeData!['website'].toString().isNotEmpty) {
      response += "• 🌐 **Website:** ${_collegeData!['website']}\n";
    } else {
      response += "• 🌐 **Website:** Not available\n";
    }

    // Add address if available
    if (_collegeData!['address'] != null &&
        _collegeData!['address'].toString().isNotEmpty) {
      response += "• 📍 **Address:** ${_collegeData!['address']}\n";
    } else {
      response += "• 📍 **Address:** Not available\n";
    }

    // Add office hours if available
    if (_collegeData!['officeHours'] != null &&
        _collegeData!['officeHours'].toString().isNotEmpty) {
      response += "• 🕒 **Office Hours:** ${_collegeData!['officeHours']}\n";
    } else {
      response += "• 🕒 **Office Hours:** Standard college hours\n";
    }

    response += "\n**Admission Requirements:**\n";

    // Add admission requirements if available
    if (_collegeData!['admissionRequirements'] != null &&
        _collegeData!['admissionRequirements']['documents'] != null) {
      final documents =
          _collegeData!['admissionRequirements']['documents'] as List;
      if (documents.isNotEmpty) {
        for (var doc in documents) {
          if (doc['title'] != null && doc['title'].toString().isNotEmpty) {
            response += "• ${doc['title']}\n";
          }
        }
      } else {
        response +=
            "• Please contact administration for admission requirements\n";
      }
    } else {
      response +=
          "• Please contact administration for admission requirements\n";
    }

    response +=
        "\nFor more detailed information, please visit the administration office.";

    return response;
  }

  String _buildCourseDetailResponse(Map<String, dynamic> data) {
    String response =
        """
📘 **${data['name'] ?? 'Course'} Details**

• **Course Code:** ${data['code'] ?? 'N/A'}
• **Department:** ${data['department'] ?? 'N/A'}""";

    if (data['credits'] != null) {
      response += "\n• **Credits:** ${data['credits']}";
    }
    if (data['semester'] != null) {
      response += "\n• **Semester:** ${data['semester']}";
    }

    final semesterFees = data['semesterFees'] ?? data['fees'] ?? data['fee'];
    if (semesterFees != null) {
      response += "\n• **Semester Fees:** ₹$semesterFees";
    }

    if (data['description'] != null) {
      response += "\n\n**Description:** ${data['description']}";
    }

    return response;
  }

  String _findSimilarCourses(
    String query,
    List<QueryDocumentSnapshot> courses,
  ) {
    final queryLower = query.toLowerCase();
    final similarCourses = courses.where((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final courseName = data['name']?.toString().toLowerCase() ?? '';
      final courseCode = data['code']?.toString().toLowerCase() ?? '';

      return courseName.contains(queryLower) ||
          courseCode.contains(queryLower) ||
          queryLower.contains(courseName) ||
          queryLower.contains(courseCode);
    }).toList();

    if (similarCourses.isEmpty) {
      return "I couldn't find a course matching '$query'. Here are all available courses:\n\n${_buildAllCoursesSummary(courses)}";
    }

    String response = "🔍 **Courses matching '$query':**\n\n";
    for (var doc in similarCourses) {
      final data = doc.data() as Map<String, dynamic>;
      response += "• ${data['name']} (${data['code']})\n";
    }
    response += "\nAsk about a specific course for more details!";

    return response;
  }

  String _buildAllCoursesSummary(List<QueryDocumentSnapshot> courses) {
    String response = "📚 **Available Courses:**\n\n";

    for (var i = 0; i < courses.length && i < 8; i++) {
      final data = courses[i].data() as Map<String, dynamic>;
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

    if (courses.length > 8) {
      response += "\n... and ${courses.length - 8} more courses available.";
    }

    response +=
        "\n\nAsk about a specific course for more details! (e.g., 'BCA fees' or 'Computer Science course details')";

    return response;
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

      // If specific course is detected, show only that course
      if (specificCourse != null) {
        for (var doc in courses.docs) {
          final data = doc.data();
          final courseName = data['name']?.toString() ?? '';

          if (courseName.toLowerCase() == specificCourse.toLowerCase()) {
            _printToTerminal("📚", "Displaying detailed info for: $courseName");
            return _buildCourseDetailResponse(data);
          }
        }

        // If we get here, the specific course wasn't found exactly
        // Show courses that might be what the user meant
        return _findSimilarCourses(query, courses.docs);
      }

      // Show all courses summary
      return _buildAllCoursesSummary(courses.docs);
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

🏫 **COLLEGE INFORMATION**
• "College contact details"
• "College address and phone"
• "Email and website information"
• "Office hours"
• "College location"
• "Where is the college?"
• "Contact details" (even without saying 'college')

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
        backgroundColor: Colors.white,
        leading: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            // If you want a border, you can add it here
            // border: Border.all(color: Colors.white, width: 2),
          ),
          child: ClipOval(
            child: Image.asset('assets/images/logo.jpg', fit: BoxFit.cover),
          ),
        ),
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
          ],
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
