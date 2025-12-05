import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/Featurs/college/cloudnary_uplaod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';


class SendNotificationScreen extends StatefulWidget {
  const SendNotificationScreen({Key? key}) : super(key: key);

  @override
  _SendNotificationScreenState createState() => _SendNotificationScreenState();
}

class _SendNotificationScreenState extends State<SendNotificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CloudneryUploader _cloudinaryUploader = CloudneryUploader();
  final ImagePicker _picker = ImagePicker();
  
  XFile? _selectedImage;
  bool _isSending = false;
  bool _isFetchingCount = false;
  int _userCount = 0;
  double _uploadProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchUserCount();
  }

  Future<void> _fetchUserCount() async {
    setState(() => _isFetchingCount = true);
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'user')
          .get();
      _userCount = querySnapshot.size;
    } catch (e) {
      print('Error fetching user count: $e');
    }
    setState(() => _isFetchingCount = false);
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 1920,
    );
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  Future<String?> _uploadImageToCloudinary() async {
    if (_selectedImage == null) return null;
    
    setState(() => _uploadProgress = 0.1);
    
    try {
      // Simulate upload progress
      for (double progress = 0.1; progress < 0.9; progress += 0.1) {
        await Future.delayed(Duration(milliseconds: 100));
        setState(() => _uploadProgress = progress);
      }
      
      final imageUrl = await _cloudinaryUploader.uploadFile(_selectedImage!);
      
      setState(() => _uploadProgress = 1.0);
      await Future.delayed(Duration(milliseconds: 300));
      setState(() => _uploadProgress = 0.0);
      
      return imageUrl;
    } catch (e) {
      print('Error uploading to Cloudinary: $e');
      setState(() => _uploadProgress = 0.0);
      return null;
    }
  }

  Future<void> _sendNotificationToAllUsers() async {
    if (_formKey.currentState!.validate()) {
      if (_userCount == 0) {
        _showSnackBar('No users found with role "user"');
        return;
      }

      setState(() => _isSending = true);

      try {
        // Upload image to Cloudinary if exists
        String? imageUrl;
        if (_selectedImage != null) {
          imageUrl = await _uploadImageToCloudinary();
          if (imageUrl == null && _selectedImage != null) {
            _showSnackBar('Failed to upload image. Sending without image...');
          }
        }

        // Get all users with 'user' role
        final usersSnapshot = await _firestore
            .collection('users')
            .where('role', isEqualTo: 'user')
            .get();

        final userDocs = usersSnapshot.docs;

        // Prepare notification data
        final notificationData = {
          'title': _titleController.text.trim(),
          'description': _descriptionController.text.trim(),
          'imageUrl': imageUrl,
          'senderId': 'admin_user_id', // Replace with actual admin ID
          'timestamp': FieldValue.serverTimestamp(),
          'read': false,
          'type': 'broadcast',
        };

        // Send to each user
        final batch = _firestore.batch();
        
        for (final userDoc in userDocs) {
          final notificationRef = _firestore
              .collection('users')
              .doc(userDoc.id)
              .collection('notifications')
              .doc();
          
          batch.set(notificationRef, notificationData);
        }

        // Also save to notifications collection
        final broadcastRef = _firestore.collection('notifications').doc();
        batch.set(broadcastRef, {
          ...notificationData,
          'receiversCount': userDocs.length,
          'targetRole': 'user',
          'sentBy': 'admin_user_id',
        });

        await batch.commit();

        _showSnackBar(
          '✅ Notification sent to ${userDocs.length} users successfully!',
          isError: false,
        );

        Navigator.pop(context, true);
      } catch (e) {
        print('Error sending notification: $e');
        _showSnackBar('❌ Failed to send notification: ${e.toString()}');
      } finally {
        setState(() => _isSending = false);
      }
    }
  }

  void _showSnackBar(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(isError ? Icons.error_outline : Icons.check_circle,
                color: Colors.white),
            SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: isError ? Colors.red.shade700 : Colors.green.shade700,
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send Notification'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            if (_isSending) {
              _showConfirmationDialog();
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User count and role info
              _buildUserCountCard(),
              SizedBox(height: 20),

              // Title field
              _buildTitleField(),
              SizedBox(height: 16),

              // Description field
              _buildDescriptionField(),
              SizedBox(height: 20),

              // Image selection
              _buildImageSelectionSection(),
              
              // Progress indicator for upload
              if (_uploadProgress > 0) _buildUploadProgress(),

              SizedBox(height: 30),

              // Send button
              _buildSendButton(),
              
              // Additional info
              _buildAdditionalInfo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserCountCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.blue.shade100, width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.group, color: Colors.blue, size: 24),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Broadcast to All Users',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 6),
                  _isFetchingCount
                      ? Row(
                          children: [
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Loading users...',
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ],
                        )
                      : Text(
                          'This will be sent to $_userCount user(s) with "user" role',
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 14,
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

  Widget _buildTitleField() {
    return TextFormField(
      controller: _titleController,
      decoration: InputDecoration(
        labelText: 'Title *',
        hintText: 'Enter notification title',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        prefixIcon: Icon(Icons.title),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a title';
        }
        if (value.length > 100) {
          return 'Title must be less than 100 characters';
        }
        return null;
      },
      maxLength: 100,
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      maxLines: 5,
      decoration: InputDecoration(
        labelText: 'Description *',
        hintText: 'Enter notification description',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        alignLabelWithHint: true,
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a description';
        }
        if (value.length > 1000) {
          return 'Description must be less than 1000 characters';
        }
        return null;
      },
      maxLength: 1000,
    );
  }

  Widget _buildImageSelectionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Add Image (Optional)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(width: 8),
            Text(
              'Cloudinary',
              style: TextStyle(
                fontSize: 12,
                color: Colors.blue,
                backgroundColor: Colors.blue.shade50,
                // padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                // borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.shade300,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey.shade50,
            ),
            child: _selectedImage != null
                ? Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          File(_selectedImage!.path),
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_photo_alternate,
                          size: 48, color: Colors.grey.shade400),
                      SizedBox(height: 12),
                      Text(
                        'Tap to upload image',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Supports JPG, PNG, PDF, Video',
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        
        // Image info and remove button
        if (_selectedImage != null)
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    _selectedImage!.name,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                TextButton.icon(
                  icon: Icon(Icons.delete_outline, size: 16),
                  label: Text('Remove'),
                  onPressed: () {
                    setState(() {
                      _selectedImage = null;
                    });
                  },
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildUploadProgress() {
    return Column(
      children: [
        SizedBox(height: 16),
        LinearProgressIndicator(
          value: _uploadProgress,
          backgroundColor: Colors.grey.shade200,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          minHeight: 6,
          borderRadius: BorderRadius.circular(3),
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_upload, size: 16, color: Colors.blue),
            SizedBox(width: 8),
            Text(
              'Uploading to Cloudinary...',
              style: TextStyle(
                fontSize: 12,
                color: Colors.blue.shade700,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSendButton() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            icon: _isSending
                ? SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  )
                : Icon(Icons.send_and_archive),
            label: Text(
              _isSending ? 'Sending...' : 'Send Notification',
              style: TextStyle(fontSize: 16),
            ),
            onPressed: _isSending || _userCount == 0
                ? null
                : _sendNotificationToAllUsers,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.blue.shade700,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
          ),
        ),
        
        // Progress info while sending
        if (_isSending)
          Padding(
            padding: EdgeInsets.only(top: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.notifications_active, size: 16, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  'Sending to $_userCount users...',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildAdditionalInfo() {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.blue, size: 18),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Images are uploaded to Cloudinary and notifications are sent to all users with "user" role.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade700,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cancel Sending?'),
        content: Text('Notification is being sent. Are you sure you want to cancel?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close screen
            },
            child: Text(
              'Yes, Cancel',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}