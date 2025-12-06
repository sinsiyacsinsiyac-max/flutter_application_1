import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class UserNotificationsScreen extends StatefulWidget {
  final String userId;

  const UserNotificationsScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _UserNotificationsScreenState createState() => _UserNotificationsScreenState();
}

class _UserNotificationsScreenState extends State<UserNotificationsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;
  bool _hasNewNotifications = false;
  List<Map<String, dynamic>> _notifications = [];
  Set<String> _selectedNotifications = {};

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() => _isLoading = true);
    
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .doc(widget.userId)
          .collection('notifications')
          .orderBy('timestamp', descending: true)
          .get();

      _notifications = querySnapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data(),
          'timestamp': (doc.data()['timestamp'] as Timestamp).toDate(),
        };
      }).toList();

      // Check for unread notifications
      _hasNewNotifications = _notifications.any((notif) => notif['read'] == false);
    } catch (e) {
      print('Error loading notifications: $e');
    }
    
    setState(() => _isLoading = false);
  }

  Future<void> _markAsRead(String notificationId) async {
    try {
      await _firestore
          .collection('users')
          .doc(widget.userId)
          .collection('notifications')
          .doc(notificationId)
          .update({'read': true});
      
      // Update local state
      final index = _notifications.indexWhere((n) => n['id'] == notificationId);
      if (index != -1) {
        setState(() {
          _notifications[index]['read'] = true;
        });
      }
    } catch (e) {
      print('Error marking as read: $e');
    }
  }

  Future<void> _markAllAsRead() async {
    try {
      final batch = _firestore.batch();
      
      for (final notification in _notifications) {
        if (notification['read'] == false) {
          final docRef = _firestore
              .collection('users')
              .doc(widget.userId)
              .collection('notifications')
              .doc(notification['id']);
          batch.update(docRef, {'read': true});
          
          // Update local state
          final index = _notifications.indexWhere((n) => n['id'] == notification['id']);
          if (index != -1) {
            _notifications[index]['read'] = true;
          }
        }
      }
      
      await batch.commit();
      setState(() {
        _hasNewNotifications = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('All notifications marked as read')),
      );
    } catch (e) {
      print('Error marking all as read: $e');
    }
  }

  Future<void> _deleteNotification(String notificationId) async {
    try {
      await _firestore
          .collection('users')
          .doc(widget.userId)
          .collection('notifications')
          .doc(notificationId)
          .delete();
      
      setState(() {
        _notifications.removeWhere((n) => n['id'] == notificationId);
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Notification deleted')),
      );
    } catch (e) {
      print('Error deleting notification: $e');
    }
  }

  Future<void> _deleteSelectedNotifications() async {
    if (_selectedNotifications.isEmpty) return;
    
    try {
      final batch = _firestore.batch();
      
      for (final id in _selectedNotifications) {
        final docRef = _firestore
            .collection('users')
            .doc(widget.userId)
            .collection('notifications')
            .doc(id);
        batch.delete(docRef);
      }
      
      await batch.commit();
      
      setState(() {
        _notifications.removeWhere((n) => _selectedNotifications.contains(n['id']));
        _selectedNotifications.clear();
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${_selectedNotifications.length} notification(s) deleted')),
      );
    } catch (e) {
      print('Error deleting selected notifications: $e');
    }
  }

  void _toggleSelection(String notificationId) {
    setState(() {
      if (_selectedNotifications.contains(notificationId)) {
        _selectedNotifications.remove(notificationId);
      } else {
        _selectedNotifications.add(notificationId);
      }
    });
  }

  void _showNotificationDetails(Map<String, dynamic> notification) {
    // Mark as read when viewing
    if (notification['read'] == false) {
      _markAsRead(notification['id']);
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => NotificationDetailsSheet(
        notification: notification,
        onDelete: () {
          Navigator.pop(context);
          _deleteNotification(notification['id']);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.notifications, color: Colors.blue),
            SizedBox(width: 8),
            Text('Notifications'),
            if (_hasNewNotifications)
              Container(
                margin: EdgeInsets.only(left: 8),
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'New',
                  style: TextStyle(fontSize: 10, color: Colors.white),
                ),
              ),
          ],
        ),
        actions: [
          if (_selectedNotifications.isNotEmpty)
            IconButton(
              icon: Icon(Icons.delete_outline),
              onPressed: _deleteSelectedNotifications,
              tooltip: 'Delete selected',
            ),
          if (_hasNewNotifications && _selectedNotifications.isEmpty)
            IconButton(
              icon: Icon(Icons.done_all),
              onPressed: _markAllAsRead,
              tooltip: 'Mark all as read',
            ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadNotifications,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Column(
        children: [
          // Selection mode indicator
          if (_selectedNotifications.isNotEmpty)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.blue.shade50,
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.blue, size: 20),
                  SizedBox(width: 8),
                  Text(
                    '${_selectedNotifications.length} selected',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: () => setState(() => _selectedNotifications.clear()),
                    child: Text('Clear'),
                  ),
                ],
              ),
            ),
          
          // Notifications list
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _notifications.isEmpty
                    ? _buildEmptyState()
                    : _buildNotificationsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 80,
            color: Colors.grey.shade400,
          ),
          SizedBox(height: 16),
          Text(
            'No notifications yet',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Notifications from the system will appear here',
            style: TextStyle(color: Colors.grey.shade500),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            icon: Icon(Icons.refresh),
            label: Text('Refresh'),
            onPressed: _loadNotifications,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade50,
              foregroundColor: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList() {
    return ListView.builder(
      itemCount: _notifications.length,
      itemBuilder: (context, index) {
        final notification = _notifications[index];
        final isSelected = _selectedNotifications.contains(notification['id']);
        
        return GestureDetector(
          onLongPress: () => _toggleSelection(notification['id']),
          child: Container(
            color: isSelected ? Colors.blue.shade50 : Colors.transparent,
            child: Column(
              children: [
                ListTile(
                  leading: _buildNotificationLeading(notification, isSelected),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification['title'] ?? 'No Title',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: notification['read'] == false
                                    ? Colors.grey.shade900
                                    : Colors.grey.shade700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (notification['read'] == false)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        notification['description'] ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  subtitle: Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Row(
                      children: [
                        Icon(Icons.access_time, size: 12, color: Colors.grey),
                        SizedBox(width: 4),
                        Text(
                          _formatTimestamp(notification['timestamp']),
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(Icons.check_circle, color: Colors.blue)
                      : Icon(Icons.chevron_right, color: Colors.grey.shade400),
                  onTap: () {
                    if (_selectedNotifications.isNotEmpty) {
                      _toggleSelection(notification['id']);
                    } else {
                      _showNotificationDetails(notification);
                    }
                  },
                ),
                Divider(height: 1, thickness: 0.5),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNotificationLeading(Map<String, dynamic> notification, bool isSelected) {
    if (isSelected) {
      return Icon(Icons.check_circle, color: Colors.blue);
    }
    
    if (notification['imageUrl'] != null && notification['imageUrl'].toString().isNotEmpty) {
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.blue.shade50,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            notification['imageUrl'].toString(),
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                Icon(Icons.image_not_supported, color: Colors.blue, size: 20),
          ),
        ),
      );
    }
    
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: notification['read'] == false ? Colors.blue.shade100 : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.notifications,
        color: notification['read'] == false ? Colors.blue : Colors.grey,
        size: 20,
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM dd, yyyy').format(timestamp);
    }
  }
}

// Notification Details Bottom Sheet
class NotificationDetailsSheet extends StatelessWidget {
  final Map<String, dynamic> notification;
  final VoidCallback onDelete;

  const NotificationDetailsSheet({
    Key? key,
    required this.notification,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(Icons.notifications, color: Colors.blue, size: 24),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Notification Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          SizedBox(height: 20),
          
          // Title
          Text(
            notification['title'] ?? 'No Title',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade900,
            ),
          ),
          SizedBox(height: 8),
          
          // Date & Time
          Row(
            children: [
              Icon(Icons.access_time, size: 16, color: Colors.grey),
              SizedBox(width: 6),
              Text(
                DateFormat('EEEE, MMMM dd, yyyy • HH:mm').format(
                  notification['timestamp'] is DateTime
                      ? notification['timestamp']
                      : DateTime.now(),
                ),
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
          SizedBox(height: 20),
          
          // Image (if available)
          if (notification['imageUrl'] != null && notification['imageUrl'].toString().isNotEmpty)
            Column(
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey.shade100,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      notification['imageUrl'].toString(),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.broken_image, size: 50, color: Colors.grey),
                            SizedBox(height: 8),
                            Text('Failed to load image'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          
          // Description
          Card(
            elevation: 0,
            color: Colors.grey.shade50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Message',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    notification['description'] ?? '',
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: Icon(Icons.delete_outline),
                  label: Text('Delete'),
                  onPressed: () {
                    Navigator.pop(context);
                    onDelete();
                  },
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  icon: Icon(Icons.close),
                  label: Text('Close'),
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }
}