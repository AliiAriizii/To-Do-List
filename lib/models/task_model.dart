import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {  // ⬅ اینجا HiveObject اضافه شد
@HiveField(0)
final String title;

@HiveField(1)
bool isCompleted;

Task({required this.title, this.isCompleted = false});
}
