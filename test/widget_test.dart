import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wish_app/main.dart';
import 'package:wish_app/studentInfo.dart';
import 'package:wish_app/newStudentInfo.dart';
import 'package:hive/hive.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(StudentInfoAdapter());
  await Hive.openBox<StudentInfo>('studentInformation');

  group('StudentListPage', () {
    testWidgets('displays the list of students', (tester) async {
      // Insert a dummy student into Hive
      final studentBox = Hive.box<StudentInfo>('studentInformation');
      final student = StudentInfo('John Doe', 'My wish', '/path/to/profile.jpg');
      studentBox.put('John Doe', student);

      await tester.pumpWidget(const MyApp());

      // Verify if student is displayed
      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('My wish'), findsOneWidget);
    });

    testWidgets('navigates to NewStudentInfo when + button is tapped', (tester) async {
      await tester.pumpWidget(const MyApp());

      // Tap on the floating action button
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Verify if NewStudentInfo screen is displayed
      expect(find.text('New Student Information'), findsOneWidget);
    });

    testWidgets('edit student functionality', (tester) async {
      // Insert a dummy student into Hive
      final studentBox = Hive.box<StudentInfo>('studentInformation');
      final student = StudentInfo('John Doe', 'My wish', '/path/to/profile.jpg');
      studentBox.put('John Doe', student);

      await tester.pumpWidget(const MyApp());

      // Tap on the edit button of the first student
      await tester.tap(find.byIcon(Icons.edit).first);
      await tester.pumpAndSettle();

      // Verify the Edit dialog is displayed
      expect(find.text('Edit Student'), findsOneWidget);

      // Edit the name and wish
      await tester.enterText(find.byType(TextField).at(0), 'Jane Doe');
      await tester.enterText(find.byType(TextField).at(1), 'New wish');

      // Tap Save
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      // Verify the updated student name and wish
      expect(find.text('Jane Doe'), findsOneWidget);
      expect(find.text('New wish'), findsOneWidget);
    });

    testWidgets('delete student functionality', (tester) async {
      // Insert a dummy student into Hive
      final studentBox = Hive.box<StudentInfo>('studentInformation');
      final student = StudentInfo('John Doe', 'My wish', '/path/to/profile.jpg');
      studentBox.put('John Doe', student);

      await tester.pumpWidget(const MyApp());

      // Tap on the delete button of the first student
      await tester.tap(find.byIcon(Icons.delete).first);
      await tester.pumpAndSettle();

      // Verify if the delete dialog is displayed
      expect(find.text('Delete Student'), findsOneWidget);
      expect(find.text('Are you sure you want to delete this student?'), findsOneWidget);

      // Tap Delete
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      // Verify the student is deleted
      expect(find.text('John Doe'), findsNothing);
    });
  });
}
