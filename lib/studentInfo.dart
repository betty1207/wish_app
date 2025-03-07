import 'package:hive/hive.dart';
part 'studentInfo.g.dart';

@HiveType(typeId: 1)
class StudentInfo{

  @HiveField(0)
  String studentName;

  @HiveField(1)
  String wishes;

  @HiveField(2)
  String profile;

  StudentInfo(this.studentName, this.wishes, this.profile);
}