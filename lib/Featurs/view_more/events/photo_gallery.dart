import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';

class PhotoGalleryList extends StatelessWidget {
  const PhotoGalleryList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 15, 26, 110),
        title: const Text('Events Gallery'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('events')
            .orderBy('eventDateTime', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return _buildEmptyState();
          }

          final events = _filterPastEventsWithImages(snapshot.data!.docs);
          return _buildEventsList(context, events);
        },
      ),
    );
  }

  List<QueryDocumentSnapshot> _filterPastEventsWithImages(
    List<QueryDocumentSnapshot> docs,
  ) {
    final now = DateTime.now();

    return docs.where((doc) {
      final event = doc.data() as Map<String, dynamic>;
      final eventDateTime = (event['eventDateTime'] as Timestamp).toDate();
      final images = event['imageUrls'] as List<dynamic>? ?? [];

      return eventDateTime.isBefore(now) && images.isNotEmpty;
    }).toList();
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.photo_library, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No Event Photos Yet',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Check back after events for photos',
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildEventsList(
    BuildContext context,
    List<QueryDocumentSnapshot> events,
  ) {
    if (events.isEmpty) {
      return Center(
        child: Text(
          'No past events with photos',
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final eventDoc = events[index];
        final event = eventDoc.data() as Map<String, dynamic>;
        return _buildEventCard(context, event);
      },
    );
  }

  Widget _buildEventCard(BuildContext context, Map<String, dynamic> event) {
    final photos = event['imageUrls'] as List<dynamic>? ?? [];
    if (photos.isEmpty) return const SizedBox();

    return Card(
      elevation: 6,
      shadowColor: Colors.black26,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PhotoGalleryPage(event: event),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: SizedBox(
                height: 200,
                child: Stack(
                  children: [
                    Row(
                      children: List.generate(3, (i) {
                        if (i >= photos.length) {
                          return Expanded(
                            child: Container(color: Colors.grey[200]),
                          );
                        }
                        return Expanded(
                          child: Container(
                            margin: EdgeInsets.only(
                              left: i > 0 ? 2 : 0,
                              right: i < 2 ? 2 : 0,
                            ),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(photos[i]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.photo_library,
                              size: 16,
                              color: _getEventColor(event['category']),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${photos.length} Photos',
                              style: TextStyle(
                                color: _getEventColor(event['category']),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
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
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event['name'] ?? 'Event',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 15, 26, 110),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 6),
                      Text(
                        event['date'] ?? '',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: _getEventColor(event['category']),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getEventColor(String? category) {
    switch (category) {
      case 'Cultural':
        return Colors.purple.shade700;
      case 'Technical':
        return Colors.blue.shade700;
      case 'Sports':
        return Colors.green.shade700;
      case 'Workshop':
        return Colors.orange.shade700;
      case 'Seminar':
        return Colors.teal.shade700;
      default:
        return Colors.grey.shade700;
    }
  }
}

class PhotoGalleryPage extends StatelessWidget {
  final Map<String, dynamic> event;

  const PhotoGalleryPage({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final photos = event['imageUrls'] as List<dynamic>? ?? [];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        title: Text(event['name'] ?? 'Event Gallery'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '${photos.length} Photos',
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 1,
        ),
        itemCount: photos.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      FullScreenImage(event: event, index: index),
                ),
              );
            },
            child: Hero(
              tag: 'photo_${event['name']}_$index',
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.1),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        photos[index],
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: Colors.grey[900],
                            child: Center(
                              child: CircularProgressIndicator(
                                value:
                                    loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                    : null,
                                color: _getEventColor(event['category']),
                                strokeWidth: 2,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  _getEventColor(event['category']),
                                  _getEventColor(
                                    event['category'],
                                  ).withOpacity(0.7),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.image_not_supported,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                          );
                        },
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.7),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            '#${index + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
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
        },
      ),
    );
  }

  Color _getEventColor(String? category) {
    switch (category) {
      case 'Cultural':
        return Colors.purple.shade700;
      case 'Technical':
        return Colors.blue.shade700;
      case 'Sports':
        return Colors.green.shade700;
      case 'Workshop':
        return Colors.orange.shade700;
      case 'Seminar':
        return Colors.teal.shade700;
      default:
        return Colors.grey.shade700;
    }
  }
}

class FullScreenImage extends StatefulWidget {
  final Map<String, dynamic> event;
  final int index;

  const FullScreenImage({Key? key, required this.event, required this.index})
    : super(key: key);

  @override
  State<FullScreenImage> createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  bool _isSharing = false;

  Future<void> _shareImage() async {
    setState(() {
      _isSharing = true;
    });

    try {
      final photos = widget.event['imageUrls'] as List<dynamic>? ?? [];
      final imageUrl = photos[widget.index];

      // Share the image URL directly
      await Share.share(
        'Check out this photo from ${widget.event['name']}!\n\n$imageUrl',
        subject: 'Photo from ${widget.event['name']}',
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to share image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isSharing = false;
      });
    }
  }

  Future<void> _shareImageAsFile() async {
    setState(() {
      _isSharing = true;
    });

    try {
      final photos = widget.event['imageUrls'] as List<dynamic>? ?? [];
      final imageUrl = photos[widget.index];

      // Download the image
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;

        // Create a temporary file and share (this is a simplified version)
        // Note: For complete file sharing, you might want to use the share_plus
        // XFile sharing feature with proper temporary file creation

        await Share.share(
          'Check out this photo from ${widget.event['name']}!',
          subject: 'Photo from ${widget.event['name']}',
        );
      } else {
        throw Exception('Failed to download image');
      }
    } catch (e) {
      // Fallback to sharing the URL
      await _shareImage();
    } finally {
      setState(() {
        _isSharing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final photos = widget.event['imageUrls'] as List<dynamic>? ?? [];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text('Photo ${widget.index + 1} of ${photos.length}'),
        actions: [
          _isSharing
              ? const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                )
              : IconButton(
                  icon: const Icon(Icons.share, color: Colors.white),
                  onPressed: _shareImage,
                ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              if (value == 'share_url') {
                _shareImage();
              } else if (value == 'share_file') {
                _shareImageAsFile();
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'share_url',
                child: Row(
                  children: [
                    Icon(Icons.link),
                    SizedBox(width: 8),
                    Text('Share Image Link'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'share_file',
                child: Row(
                  children: [
                    Icon(Icons.file_copy),
                    SizedBox(width: 8),
                    Text('Share Image File'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: Hero(
          tag: 'photo_${widget.event['name']}_${widget.index}',
          child: InteractiveViewer(
            minScale: 0.5,
            maxScale: 4.0,
            child: Image.network(
              photos[widget.index],
              fit: BoxFit.contain,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                            : null,
                        color: _getEventColor(widget.event['category']),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Loading...',
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                    ],
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [
                        _getEventColor(widget.event['category']),
                        _getEventColor(
                          widget.event['category'],
                        ).withOpacity(0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.image_not_supported,
                          size: 80,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Failed to load image',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.black87,
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: widget.index > 0
                  ? () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FullScreenImage(
                            event: widget.event,
                            index: widget.index - 1,
                          ),
                        ),
                      );
                    }
                  : null,
            ),
            Expanded(
              child: Text(
                widget.event['name'] ?? 'Event',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
              onPressed: widget.index < photos.length - 1
                  ? () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FullScreenImage(
                            event: widget.event,
                            index: widget.index + 1,
                          ),
                        ),
                      );
                    }
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Color _getEventColor(String? category) {
    switch (category) {
      case 'Cultural':
        return Colors.purple.shade700;
      case 'Technical':
        return Colors.blue.shade700;
      case 'Sports':
        return Colors.green.shade700;
      case 'Workshop':
        return Colors.orange.shade700;
      case 'Seminar':
        return Colors.teal.shade700;
      default:
        return Colors.grey.shade700;
    }
  }
}
