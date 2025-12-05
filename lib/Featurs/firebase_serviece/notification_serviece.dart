import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/Featurs/college/cloudnary_uplaod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NotificationServiceWithCloudinary {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CloudneryUploader _cloudinaryUploader = CloudneryUploader();

  // Replace with your Firebase Server Key from Firebase Console -> Project Settings -> Cloud Messaging
  static const String _serverKey =
      'BOY_lXPQPwTsVarsW45XunQ5uCdprPf3auPpCt8IkV0t-2zs7zeSJLlLkpcTd9pDvoX_8AEGKGJGnuM5tnjhf_k';

  // Get all users with 'user' role along with their FCM tokens
  Future<List<Map<String, dynamic>>> getUsersWithUserRole() async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'user')
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'userId': doc.id,
          'fcmToken':
              data['fcmToken'] ??
              '', // Assuming FCM token is stored in user document
        };
      }).toList();
    } catch (e) {
      print('Error fetching users with user role: $e');
      rethrow;
    }
  }

  // Upload image using Cloudinary
  Future<String?> uploadImage(XFile imageFile) async {
    try {
      return await _cloudinaryUploader.uploadFile(imageFile);
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  // Send FCM push notification
  Future<void> _sendFCMNotification({
    required String fcmToken,
    required String title,
    required String body,
    String? imageUrl,
    Map<String, dynamic>? data,
  }) async {
    if (fcmToken.isEmpty) {
      print('FCM token is empty, skipping push notification');
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$_serverKey',
        },
        body: jsonEncode({
          'to': fcmToken,
          'priority': 'high',
          'notification': {
            'title': title,
            'body': body,
            'sound': 'default',
            'badge': '1',
            if (imageUrl != null) 'image': imageUrl,
          },
          'data': {
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'type': 'broadcast',
            'imageUrl': imageUrl ?? '',
            ...?data,
          },
          'android': {
            'priority': 'high',
            'notification': {
              'channel_id': '1',
              'sound': 'default',
              'priority': 'high',
              if (imageUrl != null) 'image': imageUrl,
            },
          },
          'apns': {
            'payload': {
              'aps': {
                'sound': 'default',
                'badge': 1,
                if (imageUrl != null) 'mutable-content': 1,
              },
            },
            if (imageUrl != null) 'fcm_options': {'image': imageUrl},
          },
        }),
      );

      if (response.statusCode == 200) {
        print('FCM notification sent successfully');
      } else {
        print(
          'Failed to send FCM notification: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Error sending FCM notification: $e');
    }
  }

  // Send notification to all users with 'user' role
  Future<void> sendNotificationToUserRole({
    required String title,
    required String description,
    XFile? imageFile,
    required String senderId,
  }) async {
    try {
      // Get all users with 'user' role
      List<Map<String, dynamic>> users = await getUsersWithUserRole();

      if (users.isEmpty) {
        throw Exception('No users found with role "user"');
      }

      String? imageUrl;

      // Upload image if exists
      if (imageFile != null) {
        imageUrl = await uploadImage(imageFile);
      }

      // Create notification data
      Map<String, dynamic> notificationData = {
        'title': title,
        'description': description,
        'imageUrl': imageUrl,
        'senderId': senderId,
        'timestamp': FieldValue.serverTimestamp(),
        'read': false,
        'type': 'broadcast',
      };

      // Use batch for better performance
      WriteBatch batch = _firestore.batch();
      List<String> userIds = [];
      int successCount = 0;

      // Send to each user with 'user' role
      for (var user in users) {
        String userId = user['userId'];
        String fcmToken = user['fcmToken'] ?? '';

        userIds.add(userId);

        // Add to Firestore batch
        DocumentReference notificationRef = _firestore
            .collection('users')
            .doc(userId)
            .collection('notifications')
            .doc();

        batch.set(notificationRef, notificationData);

        // Send FCM push notification
        if (fcmToken.isNotEmpty) {
          await _sendFCMNotification(
            fcmToken: fcmToken,
            title: title,
            body: description,
            imageUrl: imageUrl,
            data: {'notificationId': notificationRef.id, 'senderId': senderId},
          );
          successCount++;
        }
      }

      // Commit batch write
      await batch.commit();

      // Store in notifications collection for analytics
      await _firestore.collection('notifications').add({
        ...notificationData,
        'receivers': userIds,
        'totalReceivers': userIds.length,
        'targetRole': 'user',
        'sentBy': senderId,
        'pushNotificationsSent': successCount,
      });

      print(
        'Notification sent to ${userIds.length} users (${successCount} push notifications sent)',
      );
    } catch (e) {
      print('Error sending notification to user role: $e');
      rethrow;
    }
  }

  // Get user count with 'user' role
  Future<int> getUserRoleCount() async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'user')
          .get();

      return querySnapshot.size;
    } catch (e) {
      print('Error getting user role count: $e');
      return 0;
    }
  }

  // Mark notification as read
  Future<void> markNotificationAsRead(
    String userId,
    String notificationId,
  ) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .doc(notificationId)
          .update({'read': true});
    } catch (e) {
      print('Error marking notification as read: $e');
    }
  }

  // Get unread notification count for a user
  Future<int> getUnreadNotificationCount(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .where('read', isEqualTo: false)
          .get();

      return querySnapshot.size;
    } catch (e) {
      print('Error getting unread notification count: $e');
      return 0;
    }
  }
}
