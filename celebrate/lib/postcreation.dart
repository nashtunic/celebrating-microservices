import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'services/post_service.dart';
import 'services/user_service.dart';
import 'models/user.dart';
import 'models/post.dart';

class Postcreation extends StatefulWidget {
  const Postcreation({super.key});

  @override
  State<Postcreation> createState() => _PostcreationState();
}

class _PostcreationState extends State<Postcreation> {
  final PostService _postService = PostService();
  final UserService _userService = UserService();
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  User? _currentUser;
  List<String> _selectedMediaPaths = [];
  String _selectedCelebrationType = 'BIRTHDAY'; // Default type
  bool _isPrivate = false;
  bool _isLoading = false;
  bool _isPosting = false;

  final List<String> _celebrationTypes = [
    'BIRTHDAY',
    'ANNIVERSARY',
    'GRADUATION',
    'WEDDING',
    'ACHIEVEMENT',
    'OTHER'
  ];

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentUser() async {
    try {
      final user = await _userService.getCurrentUser();
      setState(() {
        _currentUser = user;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading user: $e')),
        );
      }
    }
  }

  Future<void> _pickMedia() async {
    try {
      final XFile? media = await _picker.pickImage(source: ImageSource.gallery);
      if (media != null) {
        setState(() {
          _selectedMediaPaths.add(media.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking media: $e')),
        );
      }
    }
  }

  Future<void> _createPost() async {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a title')),
      );
      return;
    }

    if (_contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter some content')),
      );
      return;
    }

    setState(() {
      _isPosting = true;
    });

    try {
      final post = await _postService.createPost(
        title: _titleController.text,
        content: _contentController.text,
        celebrationType: _selectedCelebrationType,
        mediaUrls: _selectedMediaPaths,
        isPrivate: _isPrivate,
      );

      if (mounted) {
        Navigator.pop(context, post);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating post: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isPosting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
        actions: [
          if (_isPosting)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _createPost,
            ),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        hintText: 'Enter your celebration title',
                      ),
                      maxLength: 255,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _contentController,
                      decoration: const InputDecoration(
                        labelText: 'Content',
                        hintText: 'Share your celebration...',
                      ),
                      maxLines: 5,
                      maxLength: 1000,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedCelebrationType,
                      decoration: const InputDecoration(
                        labelText: 'Celebration Type',
                      ),
                      items: _celebrationTypes.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedCelebrationType = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    if (_selectedMediaPaths.isNotEmpty) ...[
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _selectedMediaPaths.length,
                          itemBuilder: (context, index) {
                            return Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.file(
                                    File(_selectedMediaPaths[index]),
                                    height: 80,
                                    width: 80,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () {
                                      setState(() {
                                        _selectedMediaPaths.removeAt(index);
                                      });
                                    },
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    ElevatedButton.icon(
                      icon: const Icon(Icons.add_photo_alternate),
                      label: const Text('Add Media'),
                      onPressed: _pickMedia,
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: const Text('Private Post'),
                      subtitle: const Text(
                          'Only you and selected friends can see this post'),
                      value: _isPrivate,
                      onChanged: (bool value) {
                        setState(() {
                          _isPrivate = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
