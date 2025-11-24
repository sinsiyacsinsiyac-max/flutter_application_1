import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Main Amenities List Screen
class CollegeAmenitiesPanel extends StatefulWidget {
  const CollegeAmenitiesPanel({Key? key}) : super(key: key);

  @override
  State<CollegeAmenitiesPanel> createState() => _CollegeAmenitiesPanelState();
}

class _CollegeAmenitiesPanelState extends State<CollegeAmenitiesPanel> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('College Amenities'),
        backgroundColor: Colors.teal.shade700,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('amenities').orderBy('name').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return _buildEmptyState();
          }

          return _buildAmenitiesList(snapshot.data!.docs);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddAmenityScreen(),
            ),
          );
          
          if (result != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Amenity added successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        backgroundColor: Colors.teal.shade700,
        icon: const Icon(Icons.add),
        label: const Text('Add Amenity'),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.apartment, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No Amenities Yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the button below to add your first amenity',
            style: TextStyle(color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildAmenitiesList(List<QueryDocumentSnapshot> docs) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: docs.length,
      itemBuilder: (context, index) {
        final amenity = docs[index].data() as Map<String, dynamic>;
        final amenityId = docs[index].id;
        
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: _getAmenityColor(amenity['category']),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getAmenityIcon(amenity['category']),
                color: Colors.white,
                size: 30,
              ),
            ),
            title: Text(
              amenity['name'] ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(amenity['category'] ?? ''),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 14, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Expanded(child: Text(amenity['location'] ?? '')),
                  ],
                ),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: amenity['available'] == true
                        ? Colors.green.shade50 
                        : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    amenity['available'] == true ? 'Available' : 'Unavailable',
                    style: TextStyle(
                      color: amenity['available'] == true
                          ? Colors.green.shade700 
                          : Colors.red.shade700,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AmenityDetailScreen(
                    amenityId: amenityId,
                    amenity: amenity,
                  ),
                ),
              );
              
              if (result == 'delete') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Amenity deleted'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }

  Color _getAmenityColor(String category) {
    switch (category) {
      case 'Library':
        return Colors.blue.shade700;
      case 'Sports':
        return Colors.green.shade700;
      case 'Laboratory':
        return Colors.orange.shade700;
      case 'Cafeteria':
        return Colors.red.shade700;
      case 'Auditorium':
        return Colors.purple.shade700;
      case 'Hostel':
        return Colors.indigo.shade700;
      case 'Transport':
        return Colors.cyan.shade700;
      case 'Medical':
        return Colors.pink.shade700;
      default:
        return Colors.teal.shade700;
    }
  }

  IconData _getAmenityIcon(String category) {
    switch (category) {
      case 'Library':
        return Icons.local_library;
      case 'Sports':
        return Icons.sports_basketball;
      case 'Laboratory':
        return Icons.science;
      case 'Cafeteria':
        return Icons.restaurant;
      case 'Auditorium':
        return Icons.theater_comedy;
      case 'Hostel':
        return Icons.hotel;
      case 'Transport':
        return Icons.directions_bus;
      case 'Medical':
        return Icons.local_hospital;
      default:
        return Icons.apartment;
    }
  }
}

// Add Amenity Screen
class AddAmenityScreen extends StatefulWidget {
  const AddAmenityScreen({Key? key}) : super(key: key);

  @override
  State<AddAmenityScreen> createState() => _AddAmenityScreenState();
}

class _AddAmenityScreenState extends State<AddAmenityScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _capacityController = TextEditingController();
  final _contactController = TextEditingController();
  final _timingsController = TextEditingController();
  
  String _selectedCategory = 'Library';
  bool _isAvailable = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _capacityController.dispose();
    _contactController.dispose();
    _timingsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Amenity'),
        backgroundColor: Colors.teal.shade700,
      ),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Amenity Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.apartment),
                    hintText: 'e.g., Central Library',
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.category),
                  ),
                  items: const [
                    'Library',
                    'Sports',
                    'Laboratory',
                    'Cafeteria',
                    'Auditorium',
                    'Hostel',
                    'Transport',
                    'Medical',
                    'Other',
                  ].map((category) {
                    return DropdownMenuItem(value: category, child: Text(category));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.description),
                    hintText: 'Describe the amenity...',
                  ),
                  maxLines: 3,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(
                    labelText: 'Location',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_on),
                    hintText: 'e.g., Block A, Ground Floor',
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _capacityController,
                  decoration: const InputDecoration(
                    labelText: 'Capacity',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.people),
                    hintText: 'e.g., 200 people',
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _timingsController,
                  decoration: const InputDecoration(
                    labelText: 'Operating Hours',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.access_time),
                    hintText: 'e.g., 8:00 AM - 8:00 PM',
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _contactController,
                  decoration: const InputDecoration(
                    labelText: 'Contact Information',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                    hintText: 'Phone number or email',
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                Card(
                  child: SwitchListTile(
                    title: const Text('Currently Available'),
                    subtitle: Text(_isAvailable 
                        ? 'Amenity is open for use' 
                        : 'Amenity is temporarily closed'),
                    value: _isAvailable,
                    activeColor: Colors.teal.shade700,
                    onChanged: (value) {
                      setState(() {
                        _isAvailable = value;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _submitAmenity,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal.shade700,
                    padding: const EdgeInsets.all(16),
                  ),
                  child: const Text(
                    'Add Amenity',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _submitAmenity() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final newAmenity = {
          'name': _nameController.text,
          'category': _selectedCategory,
          'description': _descriptionController.text,
          'location': _locationController.text,
          'capacity': _capacityController.text,
          'timings': _timingsController.text,
          'contact': _contactController.text,
          'available': _isAvailable,
          'createdAt': FieldValue.serverTimestamp(),
        };
        
        await _firestore.collection('amenities').add(newAmenity);
        
        if (mounted) {
          Navigator.pop(context, true);
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
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }
}

// Amenity Detail Screen
class AmenityDetailScreen extends StatelessWidget {
  final String amenityId;
  final Map<String, dynamic> amenity;

  const AmenityDetailScreen({
    Key? key,
    required this.amenityId,
    required this.amenity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Amenity Details'),
        backgroundColor: Colors.teal.shade700,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'delete') {
                _showDeleteDialog(context);
              } else if (value == 'edit') {
                _editAmenity(context);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Text('Edit Amenity'),
              ),
              const PopupMenuItem(
                value: 'share',
                child: Text('Share Details'),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Text('Delete Amenity'),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Container(
              width: double.infinity,
              color: _getAmenityColor(amenity['category']),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _getAmenityIcon(amenity['category']),
                        color: Colors.white,
                        size: 40,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                amenity['category'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              amenity['name'],
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: amenity['available'] == true
                          ? Colors.green.withOpacity(0.3)
                          : Colors.red.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          amenity['available'] == true ? Icons.check_circle : Icons.cancel,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          amenity['available'] == true ? 'Available' : 'Unavailable',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Details Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Amenity Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoCard(
                    Icons.location_on,
                    'Location',
                    amenity['location'],
                    Colors.red.shade700,
                  ),
                  _buildInfoCard(
                    Icons.people,
                    'Capacity',
                    amenity['capacity'],
                    Colors.blue.shade700,
                  ),
                  _buildInfoCard(
                    Icons.access_time,
                    'Operating Hours',
                    amenity['timings'],
                    Colors.orange.shade700,
                  ),
                  _buildInfoCard(
                    Icons.phone,
                    'Contact',
                    amenity['contact'],
                    Colors.green.shade700,
                  ),
                  
                  const SizedBox(height: 24),
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        amenity['description'],
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Booking feature coming soon!'),
                              ),
                            );
                          },
                          icon: const Icon(Icons.bookmark, color: Colors.white),
                          label: const Text(
                            'Book Now',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal.shade700,
                            padding: const EdgeInsets.all(16),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Direction feature coming soon!'),
                              ),
                            );
                          },
                          icon: Icon(Icons.directions, color: Colors.teal.shade700),
                          label: Text(
                            'Get Directions',
                            style: TextStyle(color: Colors.teal.shade700),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.teal.shade700),
                            padding: const EdgeInsets.all(16),
                          ),
                        ),
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

  Widget _buildInfoCard(IconData icon, String label, String value, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
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

  Color _getAmenityColor(String category) {
    switch (category) {
      case 'Library':
        return Colors.blue.shade700;
      case 'Sports':
        return Colors.green.shade700;
      case 'Laboratory':
        return Colors.orange.shade700;
      case 'Cafeteria':
        return Colors.red.shade700;
      case 'Auditorium':
        return Colors.purple.shade700;
      case 'Hostel':
        return Colors.indigo.shade700;
      case 'Transport':
        return Colors.cyan.shade700;
      case 'Medical':
        return Colors.pink.shade700;
      default:
        return Colors.teal.shade700;
    }
  }

  IconData _getAmenityIcon(String category) {
    switch (category) {
      case 'Library':
        return Icons.local_library;
      case 'Sports':
        return Icons.sports_basketball;
      case 'Laboratory':
        return Icons.science;
      case 'Cafeteria':
        return Icons.restaurant;
      case 'Auditorium':
        return Icons.theater_comedy;
      case 'Hostel':
        return Icons.hotel;
      case 'Transport':
        return Icons.directions_bus;
      case 'Medical':
        return Icons.local_hospital;
      default:
        return Icons.apartment;
    }
  }

  void _editAmenity(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Edit feature coming soon!'),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Amenity'),
        content: Text('Are you sure you want to delete "${amenity['name']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await FirebaseFirestore.instance
                    .collection('amenities')
                    .doc(amenityId)
                    .delete();
                
                if (context.mounted) {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context, 'delete'); // Return to list
                }
              } catch (e) {
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error deleting: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}