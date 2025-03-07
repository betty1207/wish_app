import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:wish_app/studentInfo.dart';

class NewStudentInfo extends StatefulWidget {
  const NewStudentInfo({super.key});

  @override
  State<NewStudentInfo> createState() => _NewStudentInfoState();
}

class _NewStudentInfoState extends State<NewStudentInfo> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _wishController = TextEditingController();
  File? _profileImage; // Nullable to handle no image selected
  bool _imageSelected = false; // To track if the image has been picked

  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Wish')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Name TextField
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Wish TextField
              TextField(
                controller: _wishController,
                decoration: const InputDecoration(
                  labelText: 'Wish',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Button to pick image
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Pick Profile Image'),
              ),

              // Display the picked image if available
              if (_imageSelected && _profileImage != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.file(
                    _profileImage!, // Make sure the file is properly set
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 16),

              // Save Button
              ElevatedButton(
                onPressed: _saveStudentInfo,
                child: const Text('Save'),
              ),

              // Back Button
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to pick the image
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
        _imageSelected = true;
      });

      // Debugging - Print the file path to verify it's correct
      print("Picked image path: ${pickedFile.path}");
    }
  }

  // Function to save student information
  void _saveStudentInfo() {
    final String name = _nameController.text;
    final String wish = _wishController.text;

    if (name.isNotEmpty && wish.isNotEmpty && _imageSelected) {
      // Save to Hive
      final studentInfo = StudentInfo(name, wish, _profileImage!.path); // Saving the image path
      final studentBox = Hive.box<StudentInfo>('Wish_List');
      studentBox.put(name, studentInfo); // Storing with the name as the key

      // Refresh the state after saving
      setState(() {
        // This will trigger a UI rebuild, making sure the saved image is displayed
        _profileImage = _profileImage;
        _imageSelected = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Wish_Saved!')),
      );

      // Go back to the previous screen after saving
      Navigator.of(context).pop();
    } else {
      // Show error if any field is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields and select an image.')),
      );
    }
  }
}
