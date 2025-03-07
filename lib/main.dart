import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wish_app/studentInfo.dart';
import 'package:wish_app/newStudentInfo.dart';
import 'dart:io';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(StudentInfoAdapter());
  await Hive.openBox<StudentInfo>('Wish_List');

  // Populate the Hive box with default students if the box is empty
  final studentBox = Hive.box<StudentInfo>('Wish_List');
  if (studentBox.isEmpty) {
    studentBox.put('Betelhem', StudentInfo("Betelhem", "I hope to find happiness in the little things, stay true to myself, and create a life full of love and purpose.", "assets/images/beti.jpg"));
    studentBox.put('Bezawit', StudentInfo("Bezawit", "I wish to grow stronger each day, achieve my dreams, and make a positive impact on the world around me.", "assets/images/bez.jpg"));
    studentBox.put('BezawitM', StudentInfo("Bezawit Meg", "I wish for endless opportunities to learn and grow, and to leave a legacy that makes my family proud.", "assets/images/bezis.jpg"));
    studentBox.put('Hibritu', StudentInfo("Hibritu", "I hope to live a balanced life, filled with meaningful achievements, great friendships, and inner peace", "assets/images/hibir.jpg"));
    studentBox.put('Tigist', StudentInfo("Tigist", "I wish to always stay motivated, chase my passions, and never stop believing in the power of hard work", "assets/images/tigi.jpg"));
    studentBox.put('Rediet', StudentInfo("Rediet", "I hope to lead a life of kindness and success, making a difference wherever I go and to whomever I meet.", "assets/images/red.jpg"));
    studentBox.put('Melat', StudentInfo("Melat", "I wish to stay curious, keep learning, and turn every challenge into an opportunity for growth.", "assets/images/melu.jpg"));
    studentBox.put('Ayalnesh', StudentInfo("Ayalnesh", "I hope to remain resilient, find joy in my journey, and achieve everything I set my heart on.", "assets/images/ayal.jpg"));
    studentBox.put('Ehitemuse', StudentInfo("Ehitemuse", "I wish to always stay humble, work hard, and create a future filled with success and happiness.", "assets/images/ehte.jpg"));
    studentBox.put('Afrah', StudentInfo("Afrah", "I hope to live a fulfilling life, full of laughter, love, and achievements that I can look back on with pride.", "assets/images/afru.jpg"));
    studentBox.put('Afomiya', StudentInfo("Afomiya", "I wish to keep exploring my passions, surround myself with positivity, and make every moment count.", "assets/images/afomi.jpg"));
    studentBox.put('Yordanos', StudentInfo("Yordanos", "I hope to always strive for greatness, embrace every opportunity, and live a life full of meaning and adventure.", "assets/images/yordi.jpg"));
    studentBox.put('Fikir', StudentInfo("Fikir", "I wish to always believe in myself, cherish the journey, and inspire others through my actions.", "assets/images/fikirte.jpg"));
    studentBox.put('Bisri', StudentInfo("Bisri", "I hope to overcome every obstacle, keep chasing my dreams, and create a legacy of success and kindness.", "assets/images/bisri.jpg"));
    studentBox.put('Rebki', StudentInfo("Rebki", "I wish to stay focused on my goals, celebrate my progress, and enjoy every step of my life’s journey", "assets/images/rebki.jpg"));
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wish_List',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const StudentListPage(),
    );
  }
}

class StudentListPage extends StatefulWidget {
  const StudentListPage({super.key});

  @override
  _StudentListPageState createState() => _StudentListPageState();
}

class _StudentListPageState extends State<StudentListPage> {
  final Box<StudentInfo> studentBox = Hive.box<StudentInfo>('Wish_List');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wish_List'),
      ),
      body: ValueListenableBuilder(
        valueListenable: studentBox.listenable(),
        builder: (context, Box<StudentInfo> box, _) {
          if (box.isEmpty) {
            return const Center(child: Text('No students added yet.'));
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final key = box.keys.toList()[index];
              final StudentInfo student = box.get(key)!;
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: _getImage(student.profile),
                  ),
                  title: Text(student.studentName),
                  subtitle: Text(student.wishes),
                  onTap: () {
                    // Navigate to the DetailPage when tapped
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPage(student: student),
                      ),
                    );
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          _editStudent(context, student);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _deleteStudent(context, key);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewStudentInfo()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  ImageProvider _getImage(String imagePath) {
    if (imagePath.startsWith('assets/')) {
      return AssetImage(imagePath); // Image from assets
    } else {
      final file = File(imagePath);
      if (file.existsSync()) {
        return FileImage(file); // Image from device
      } else {
        return const AssetImage('assets/images/default.jpg'); // Fallback image
      }
    }
  }

  void _editStudent(BuildContext context, StudentInfo student) {
    final TextEditingController nameController =
    TextEditingController(text: student.studentName);
    final TextEditingController wishController =
    TextEditingController(text: student.wishes);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Student'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: wishController,
                  decoration: const InputDecoration(labelText: 'Wish'),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    wishController.text.isNotEmpty) {
                  final updatedStudent = StudentInfo(
                    nameController.text,
                    wishController.text,
                    student.profile,
                  );

                  studentBox.put(student.studentName, updatedStudent);

                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('All fields must be filled.'),
                    ),
                  );
                }
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _deleteStudent(BuildContext context, dynamic key) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Student'),
          content: const Text('Are you sure you want to delete this student?'),
          actions: [
            TextButton(
              onPressed: () {
                studentBox.delete(key);
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}

class DetailPage extends StatelessWidget {
  final StudentInfo student;

  const DetailPage({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(student.studentName),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 80,
              backgroundImage: _getImage(student.profile),
            ),
            const SizedBox(height: 20),
            Text(
              student.studentName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              student.wishes,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  ImageProvider _getImage(String imagePath) {
    if (imagePath.startsWith('assets/')) {
      return AssetImage(imagePath); // Image from assets
    } else {
      final file = File(imagePath);
      if (file.existsSync()) {
        return FileImage(file); // Image from device
      } else {
        return const AssetImage('assets/images/default.jpg'); // Fallback image
      }
    }
  }
}
