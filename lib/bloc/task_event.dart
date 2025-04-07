part of 'task_bloc.dart';

abstract class TaskEvent {}

class LoadTasks extends TaskEvent {}

class AddTask extends TaskEvent {
  final Task task;
  AddTask(this.task);
}

class ToggleTask extends TaskEvent {
  final Task task;
  ToggleTask(this.task);
}

class DeleteTask extends TaskEvent {
  final Task task;
  DeleteTask(this.task);
}
