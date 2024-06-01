import 'package:assig/Feature/UpdateTask/Bloc/UpdateTask/task_update_block.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../DataStruct/Tasks.dart';

class TaskUpdate extends StatefulWidget {
  final Task task;

  const TaskUpdate({super.key, required this.task});

  @override
  State<TaskUpdate> createState() => _TaskUpdateState();



}

class _TaskUpdateState extends State<TaskUpdate> {
  TaskUpdateBloc taskUpdateBloc = TaskUpdateBloc();


  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _expectedCompTimeController =
      TextEditingController();
  DateTime? _deadline;

  Future<void> _setDeadline(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      final TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (selectedTime != null) {
        setState(() {
          _deadline = DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );
        });
      }
    }
  }

// Utility functions
  String formatDateTime(DateTime dateTime) {
    return "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} "
        "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}";
  }

  // void _setDeadline() async {
  //   final selectedDate = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime.now(),
  //     lastDate: DateTime(2100),
  //   );
  //
  //   if (selectedDate != null) {
  //     setState(() {
  //       _deadline = selectedDate;
  //     });
  //   }
  // }

  @override
  void initState() {
    // TODO: implement initState

    // print("iniitally" + widget.task.id);
    taskUpdateBloc.add(TaskUpdateInitialEvent(widget.task));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
        body: Column(
      children: [
        Container(
          height: 10,
          width: 10,


        ),
        Expanded(
          flex: 1,
          child: BlocBuilder<TaskUpdateBloc, TaskUpdateState>(
            bloc: taskUpdateBloc,
            builder: (context, state) {
              switch (state.runtimeType) {
                case TaskUpdateLoadedSuccessState:
                  final sucessState = state as TaskUpdateLoadedSuccessState;

                  return formTask(context, widget.task);

                case TaskUpdateNotFoundState:
                  return formTask(
                      context,
                      Task("_id", "_title", "_discription", "45545", "_ownerId",
                          "_expectedCompTime", "_completeStatus"));

                default:
                  return Text(
                    "nothing",
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  );
              }
            },
          ),
        ),
      ],
    ));
  }

  Widget formTask(BuildContext context, Task task) {
    // print(task.title);
    _titleController.text = task.title;
    _descriptionController.text = task.discription;
    _expectedCompTimeController.text = task.expectedCompTime;
    _deadline = DateTime.fromMicrosecondsSinceEpoch(int.parse(task.deadLine));

    // //to init _deadline
    // setState(() {
    //
    // });

    return Container(
      color: Colors.grey,

      width: double.infinity,
      height: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.white,
              constraints: BoxConstraints(
                maxWidth: 400,

              ),



              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[



                      Center(child: Text(task.id==""?"Add Task":"Update Task",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 30),)),
                      SizedBox(height: 44,),

                      TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(labelText: 'Title',contentPadding: EdgeInsets.only(left: 5)),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the title';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(labelText: 'Description',contentPadding: EdgeInsets.only(left: 5)),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the description';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _expectedCompTimeController,
                        decoration:
                            InputDecoration(labelText: 'Expected Completion Time',contentPadding: EdgeInsets.only(left: 5)),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the expected completion time';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(

                        onPressed: () => {
                          _setDeadline(context),
                          // taskUpdateBloc.add(TaskUpdateInitialEvent(task))
                        },
                        child:
                            Text(_deadline == null ? 'Set Deadline' : 'Change Deadline',),
                      ),
                      SizedBox(height: 16),
                      Text(
                        _deadline == null
                            ? 'No deadline set'
                            : ' Deadline: ${formatDateTime(_deadline!)}',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 24),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(color: Colors.orange,borderRadius: BorderRadius.all(Radius.circular(10))),
                        child: TextButton(onPressed: ()=>{
                          taskUpdateBloc.add(TaskUpdateAddOrUpdateEvent(Task(
                              task.id,
                              _titleController.text.toString(),
                              _descriptionController.text.toString(),
                              _deadline!.millisecondsSinceEpoch.toString(),
                              task.ownerId,
                              _expectedCompTimeController.text.toString(),
                              task.completeStatus))),

                        }, child: Text("Submit",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),)),
                      ),

                    ],
                  ),
                ),
              ),




            ),
          ),
        ],
      ),
    );
  }
}
