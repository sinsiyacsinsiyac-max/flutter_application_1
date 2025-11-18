import 'package:flutter/material.dart';

class PhotoGalleryList extends StatelessWidget {
  const PhotoGalleryList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pastEvents = [
      {
        'title': 'Tech Summit 2024',
        'date': 'November 10, 2024',
        'color': const Color(0xFF1976D2),
        'coverImage': 'https://images.unsplash.com/photo-1505373877841-8d25f7d46678?w=400',
        'photos': [
          'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=600',
          'https://images.unsplash.com/photo-1591115765373-5207764f72e7?w=600',
          'https://images.unsplash.com/photo-1535303311164-664fc9ec6532?w=600',
          'https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=600',
          'https://images.unsplash.com/photo-1486312338219-ce68d2c6f44d?w=600',
          'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?w=600',
          'https://images.unsplash.com/photo-1517245386807-bb43f82c33c4?w=600',
          'https://images.unsplash.com/photo-1522071820081-009f0129c71c?w=600',
          'https://images.unsplash.com/photo-1556761175-b413da4baf72?w=600',
          'https://images.unsplash.com/photo-1573164713714-d95e436ab8d6?w=600',
          'https://images.unsplash.com/photo-1519389950473-47ba0277781c?w=600',
          'https://images.unsplash.com/photo-1531482615713-2afd69097998?w=600',
        ],
      },
      {
        'title': 'Cultural Fest',
        'date': 'October 25, 2024',
        'color': const Color(0xFFE91E63),
        'coverImage': 'https://images.unsplash.com/photo-1501281668745-f7f57925c3b4?w=400',
        'photos': [
          'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=600',
          'https://images.unsplash.com/photo-1470229722913-7c0e2dbbafd3?w=600',
          'https://images.unsplash.com/photo-1501612780327-45045538702b?w=600',
          'https://images.unsplash.com/photo-1506157786151-b8491531f063?w=600',
          'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=600',
          'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=600',
          'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7?w=600',
          'https://images.unsplash.com/photo-1510511459019-5dda7724fd87?w=600',
          'https://images.unsplash.com/photo-1524368535928-5b5e00ddc76b?w=600',
          'https://images.unsplash.com/photo-1514320291840-2e0a9bf2a9ae?w=600',
          'https://images.unsplash.com/photo-1512478788965-94d8df042a63?w=600',
          'https://images.unsplash.com/photo-1496293455970-f8581aae0e3b?w=600',
          'https://images.unsplash.com/photo-1509824227185-9c5a01ceba0d?w=600',
          'https://images.unsplash.com/photo-1501386761578-eac5c94b800a?w=600',
          'https://images.unsplash.com/photo-1511192336575-5a79af67a629?w=600',
          'https://images.unsplash.com/photo-1471478331149-c72f17e33c73?w=600',
          'https://images.unsplash.com/photo-1519389950473-47ba0277781c?w=600',
          'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=600',
        ],
      },
      {
        'title': 'Sports Day',
        'date': 'October 5, 2024',
        'color': const Color(0xFF4CAF50),
        'coverImage': 'https://images.unsplash.com/photo-1579952363873-27f3bade9f55?w=400',
        'photos': [
          'https://images.unsplash.com/photo-1461896836934-ffe607ba8211?w=600',
          'https://images.unsplash.com/photo-1517649763962-0c623066013b?w=600',
          'https://images.unsplash.com/photo-1551958219-acbc608c6377?w=600',
          'https://images.unsplash.com/photo-1574629810360-7efbbe195018?w=600',
          'https://images.unsplash.com/photo-1579952363873-27f3bade9f55?w=600',
          'https://images.unsplash.com/photo-1519505907962-0a6cb0167c73?w=600',
          'https://images.unsplash.com/photo-1587280501635-68a0e82cd5ff?w=600',
          'https://images.unsplash.com/photo-1571902943202-507ec2618e8f?w=600',
          'https://images.unsplash.com/photo-1558611848-73f7eb4001a1?w=600',
          'https://images.unsplash.com/photo-1486286701208-1d58e9338013?w=600',
          'https://images.unsplash.com/photo-1552674605-db6ffd4facb5?w=600',
          'https://images.unsplash.com/photo-1577223625816-7546f13df25d?w=600',
          'https://images.unsplash.com/photo-1593016927992-4a79e38359e6?w=600',
          'https://images.unsplash.com/photo-1624880357913-a8539238245b?w=600',
          'https://images.unsplash.com/photo-1546519638-68e109498ffc?w=600',
          'https://images.unsplash.com/photo-1577223625816-7546f13df25d?w=600',
          'https://images.unsplash.com/photo-1461896836934-ffe607ba8211?w=600',
          'https://images.unsplash.com/photo-1517649763962-0c623066013b?w=600',
          'https://images.unsplash.com/photo-1551958219-acbc608c6377?w=600',
          'https://images.unsplash.com/photo-1574629810360-7efbbe195018?w=600',
          'https://images.unsplash.com/photo-1579952363873-27f3bade9f55?w=600',
          'https://images.unsplash.com/photo-1519505907962-0a6cb0167c73?w=600',
          'https://images.unsplash.com/photo-1587280501635-68a0e82cd5ff?w=600',
          'https://images.unsplash.com/photo-1571902943202-507ec2618e8f?w=600',
        ],
      },
      {
        'title': 'Freshers Welcome',
        'date': 'September 15, 2024',
        'color': const Color(0xFFFF9800),
        'coverImage': 'https://images.unsplash.com/photo-1511795409834-ef04bbd61622?w=400',
        'photos': [
          'https://images.unsplash.com/photo-1511795409834-ef04bbd61622?w=600',
          'https://images.unsplash.com/photo-1543269865-cbf427effbad?w=600',
          'https://images.unsplash.com/photo-1523580494863-6f3031224c94?w=600',
          'https://images.unsplash.com/photo-1511578314322-379afb476865?w=600',
          'https://images.unsplash.com/photo-1515187029135-18ee286d815b?w=600',
          'https://images.unsplash.com/photo-1533174072545-7a4b6ad7a6c3?w=600',
          'https://images.unsplash.com/photo-1530099486328-e021101a494a?w=600',
          'https://images.unsplash.com/photo-1543269664-56d93c1b41a6?w=600',
          'https://images.unsplash.com/photo-1529156069898-49953e39b3ac?w=600',
          'https://images.unsplash.com/photo-1511632765486-a01980e01a18?w=600',
          'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=600',
          'https://images.unsplash.com/photo-1504609773096-104ff2c73ba4?w=600',
          'https://images.unsplash.com/photo-1506869640319-fe1a24fd76dc?w=600',
          'https://images.unsplash.com/photo-1543269664-02f4d2e4e1b5?w=600',
          'https://images.unsplash.com/photo-1527525443983-6e60c75fff46?w=600',
          'https://images.unsplash.com/photo-1511632765486-a01980e01a18?w=600',
          'https://images.unsplash.com/photo-1527529482837-4698179dc6ce?w=600',
          'https://images.unsplash.com/photo-1504610926078-a1611febcad3?w=600',
          'https://images.unsplash.com/photo-1517457373958-b7bdd4587205?w=600',
          'https://images.unsplash.com/photo-1523580494863-6f3031224c94?w=600',
          'https://images.unsplash.com/photo-1511578314322-379afb476865?w=600',
          'https://images.unsplash.com/photo-1515187029135-18ee286d815b?w=600',
          'https://images.unsplash.com/photo-1533174072545-7a4b6ad7a6c3?w=600',
          'https://images.unsplash.com/photo-1530099486328-e021101a494a?w=600',
          'https://images.unsplash.com/photo-1543269664-56d93c1b41a6?w=600',
          'https://images.unsplash.com/photo-1529156069898-49953e39b3ac?w=600',
          'https://images.unsplash.com/photo-1511632765486-a01980e01a18?w=600',
          'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=600',
          'https://images.unsplash.com/photo-1504609773096-104ff2c73ba4?w=600',
          'https://images.unsplash.com/photo-1506869640319-fe1a24fd76dc?w=600',
        ],
      },
      {
        'title': 'Annual Day Celebration',
        'date': 'August 28, 2024',
        'color': const Color(0xFF9C27B0),
        'coverImage': 'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=400',
        'photos': [
          'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=600',
          'https://images.unsplash.com/photo-1522158637959-30385a09e0da?w=600',
          'https://images.unsplash.com/photo-1505236858219-8359eb29e329?w=600',
          'https://images.unsplash.com/photo-1513151233558-d860c5398176?w=600',
          'https://images.unsplash.com/photo-1519225421980-715cb0215aed?w=600',
          'https://images.unsplash.com/photo-1478147427282-58a87a120781?w=600',
          'https://images.unsplash.com/photo-1496337589254-7e19d01cec44?w=600',
          'https://images.unsplash.com/photo-1501281668745-f7f57925c3b4?w=600',
          'https://images.unsplash.com/photo-1533174072545-7a4b6ad7a6c3?w=600',
          'https://images.unsplash.com/photo-1511795409834-ef04bbd61622?w=600',
          'https://images.unsplash.com/photo-1543269865-cbf427effbad?w=600',
          'https://images.unsplash.com/photo-1464366400600-7168b8af9bc3?w=600',
          'https://images.unsplash.com/photo-1505236858219-8359eb29e329?w=600',
          'https://images.unsplash.com/photo-1511632765486-a01980e01a18?w=600',
          'https://images.unsplash.com/photo-1527529482837-4698179dc6ce?w=600',
          'https://images.unsplash.com/photo-1504610926078-a1611febcad3?w=600',
          'https://images.unsplash.com/photo-1517457373958-b7bdd4587205?w=600',
          'https://images.unsplash.com/photo-1523580494863-6f3031224c94?w=600',
          'https://images.unsplash.com/photo-1511578314322-379afb476865?w=600',
          'https://images.unsplash.com/photo-1529156069898-49953e39b3ac?w=600',
          'https://images.unsplash.com/photo-1519225421980-715cb0215aed?w=600',
          'https://images.unsplash.com/photo-1478147427282-58a87a120781?w=600',
          'https://images.unsplash.com/photo-1496337589254-7e19d01cec44?w=600',
          'https://images.unsplash.com/photo-1501281668745-f7f57925c3b4?w=600',
          'https://images.unsplash.com/photo-1533174072545-7a4b6ad7a6c3?w=600',
          'https://images.unsplash.com/photo-1511795409834-ef04bbd61622?w=600',
          'https://images.unsplash.com/photo-1543269865-cbf427effbad?w=600',
          'https://images.unsplash.com/photo-1464366400600-7168b8af9bc3?w=600',
          'https://images.unsplash.com/photo-1505236858219-8359eb29e329?w=600',
          'https://images.unsplash.com/photo-1511632765486-a01980e01a18?w=600',
          'https://images.unsplash.com/photo-1527529482837-4698179dc6ce?w=600',
          'https://images.unsplash.com/photo-1504610926078-a1611febcad3?w=600',
          'https://images.unsplash.com/photo-1517457373958-b7bdd4587205?w=600',
          'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=600',
          'https://images.unsplash.com/photo-1522158637959-30385a09e0da?w=600',
          'https://images.unsplash.com/photo-1505236858219-8359eb29e329?w=600',
        ],
      },
    ];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 15, 26, 110),
        title: const Text('Events Gallery'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: pastEvents.length,
        itemBuilder: (context, index) {
          final event = pastEvents[index];
          return _buildEventCard(context, event);
        },
      ),
    );
  }

  Widget _buildEventCard(BuildContext context, Map<String, dynamic> event) {
    final photos = event['photos'] as List<String>;
    
    return Card(
      elevation: 6,
      shadowColor: Colors.black26,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
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
            // Image Grid Preview with Real Images
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: SizedBox(
                height: 200,
                child: Stack(
                  children: [
                    Row(
                      children: List.generate(3, (i) {
                        return Expanded(
                          child: Container(
                            margin: EdgeInsets.only(
                                left: i > 0 ? 2 : 0, right: i < 2 ? 2 : 0),
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
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.photo_library,
                                size: 16, color: event['color']),
                            const SizedBox(width: 6),
                            Text(
                              '${photos.length} Photos',
                              style: TextStyle(
                                color: event['color'],
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
            // Event Info
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event['title'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 15, 26, 110),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.calendar_today,
                          size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 6),
                      Text(
                        event['date'],
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const Spacer(),
                      Icon(Icons.arrow_forward_ios,
                          size: 14, color: event['color']),
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
}

// Photo Gallery Page with Real Network Images
class PhotoGalleryPage extends StatelessWidget {
  final Map<String, dynamic> event;

  const PhotoGalleryPage({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final photos = event['photos'] as List<String>;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        title: Text(event['title']),
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
                  builder: (context) => FullScreenImage(
                    event: event,
                    index: index,
                  ),
                ),
              );
            },
            child: Hero(
              tag: 'photo_${event['title']}_$index',
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
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                                color: event['color'],
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
                                  event['color'],
                                  event['color'].withOpacity(0.7),
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
                      // Gradient overlay at bottom
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
                              horizontal: 8, vertical: 4),
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
}

// Full Screen Image Viewer with Real Images
class FullScreenImage extends StatelessWidget {
  final Map<String, dynamic> event;
  final int index;

  const FullScreenImage({
    Key? key,
    required this.event,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final photos = event['photos'] as List<String>;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text('Photo ${index + 1} of ${photos.length}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Share functionality')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Download functionality')),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Hero(
          tag: 'photo_${event['title']}_$index',
          child: InteractiveViewer(
            minScale: 0.5,
            maxScale: 4.0,
            child: Image.network(
              photos[index],
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
                        color: event['color'],
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
                        event['color'],
                        event['color'].withOpacity(0.7),
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
              onPressed: index > 0
                  ? () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FullScreenImage(
                            event: event,
                            index: index - 1,
                          ),
                        ),
                      );
                    }
                  : null,
            ),
            Text(
              event['title'],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
              onPressed: index < photos.length - 1
                  ? () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FullScreenImage(
                            event: event,
                            index: index + 1,
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
  }