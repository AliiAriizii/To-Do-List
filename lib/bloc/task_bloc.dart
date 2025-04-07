import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import '../models/task_model.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final Box<Task> taskBox;

  TaskBloc(this.taskBox) : super(TaskInitial()) {
    on<LoadTasks>((event, emit) {
      final tasks = taskBox.values.toList();
      emit(TaskLoaded(tasks: tasks));
    });

    on<AddTask>((event, emit) {
      taskBox.add(event.task);
      emit(TaskLoaded(tasks: taskBox.values.toList()));
    });

    on<ToggleTask>((event, emit) {
      event.task.isCompleted = !event.task.isCompleted;
      event.task.save();
      emit(TaskLoaded(tasks: taskBox.values.toList()));
    });

    on<DeleteTask>((event, emit) {
      event.task.delete();
      emit(TaskLoaded(tasks: taskBox.values.toList()));
    });
  }
}
