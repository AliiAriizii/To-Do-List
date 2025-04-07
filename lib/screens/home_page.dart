import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/task_bloc.dart';
import '../models/task_model.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A1F44), // سرمه‌ای
      appBar: AppBar(
        title: Text(
          'Task Manager',
          style: TextStyle(color: Color(0xFFD3D3D3)), // طوسی روشن
        ),
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoaded) {
            return AnimatedList(
              key: _listKey,
              initialItemCount: state.tasks.length,
              itemBuilder: (context, index, animation) {
                final task = state.tasks[index];
                return _buildTaskItem(task, index, animation);
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFEE715), // زرد درخشان
        child: const Icon(Icons.add, color: Color(0xFF101820)), // آیکون مشکی
        onPressed: () => _showAddTaskDialog(context),
      ),
    );
  }

  Widget _buildTaskItem(Task task, int index, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: Card(
        color: const Color(0xFFB0B0B0), // طوسی متالیک
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ListTile(
          title: Text(
            task.title,
            style: TextStyle(
              color: const Color(0xFFFEE715), // زرد درخشان
              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          leading: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: task.isCompleted
                  ? const Color(0xFFFEE715) // زرد برای تسک‌های کامل‌شده
                  : Colors.grey[300], // خاکستری برای تسک‌های عادی
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(
                task.isCompleted ? Icons.check_circle : Icons.circle_outlined,
                color: task.isCompleted ? const Color(0xFF101820) : Colors.black45,
              ),
              onPressed: () {
                context.read<TaskBloc>().add(ToggleTask(task));
              },
            ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.redAccent),
            onPressed: () {
              context.read<TaskBloc>().add(DeleteTask(task));
              _listKey.currentState!.removeItem(
                index,
                (context, animation) => _buildTaskItem(task, index, animation),
                duration: const Duration(milliseconds: 300),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    String taskTitle = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFB0B0B0), // طوسی متالیک
          title: const Text(
            'Add Task',
            style: TextStyle(color: Color(0xFFFEE715)), // زرد درخشان
          ),
          content: TextField(
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Enter task title',
              hintStyle: TextStyle(color: Colors.white70),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFFEE715)), // زرد درخشان
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFFEE715)),
              ),
            ),
            onChanged: (value) => taskTitle = value,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                if (taskTitle.isNotEmpty) {
                  context.read<TaskBloc>().add(AddTask(Task(title: taskTitle)));
                  _listKey.currentState!.insertItem(0);
                }
                Navigator.pop(context);
              },
              child: const Text('Add', style: TextStyle(color: Color(0xFFFEE715))),
            ),
          ],
        );
      },
    );
  }
}
