import 'dart:async';

import 'package:assig/Feature/UpdateTask/Bloc/UpdateTask/task_update_block.dart';
import 'package:assig/KeyCon.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../DataStruct/Tasks.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  //for default passing eanbility
  TaskBloc() : super(TaskInitialState()) {
    on<TaskInitialEvent>(TaskInitialMethod);
    on<TaskViewedEvent>(TaskViewedMethod);
    on<TaskUpdateEvent>(TaskUpdateMethod);
  }

  List<Task> listTasks=[];
  Task task = Task("id", "title","discription", "455000", "partnerID","","");
  bool dataFound = true;
  String userId = "sdf";

  Future<FutureOr<void>> TaskInitialMethod(
      TaskEvent event, Emitter<TaskState> emit) async {
    FlutterSecureStorage _secureStorage = FlutterSecureStorage();
    String? tamp = await _secureStorage.read(key: 'id');



    tamp="1717057212645";
    userId=tamp!;

    print("id:dsf "+userId);

    listTasks.add(task);
    listTasks.add(task);
    listTasks.add(task);
    listTasks.add(task);


    if (tamp == null) {
      emit(TaskNotFoundState());
    }
    else{

      try {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('tasks').get();
        listTasks = querySnapshot.docs.map((doc) => Task.fromFirestore(doc)).toList();

      } catch (e) {
        print('Error fetching tasks: $e');
        emit(TaskShowErrorState("Error getting tasks"));

      }
      emit(TaskLoadedSuccessState(listTasks));
    }



    // else {
    // await FirebaseDatabase.instance
    //     .ref()
    //     .child(AllTask().taskCon)
    //     .orderByChild(AllTask().ownerId)
    //     .equalTo(userId)
    //     .get()
    //     .then((DataSnapshot snapshot) async => {
    // if (snapshot != null && snapshot != "")
    // {
    // snapshot.children.forEach((data) {
    // task = Task(
    // data.key.toString(),
    // data
    //     .child(AllTask().title)
    //     .value
    //     .toString(),
    // data.child(AllTask().discription).value.toString(),
    // data
    //     .child(AllTask().deadLine)
    //     .value
    //     .toString(),
    // data
    //     .child(AllTask().ownerId)
    //     .value
    //     .toString(),
    // data
    //     .child(AllTask().expectedCompTime)
    //     .value
    //     .toString(),
    // data
    //     .child(AllTask().completeStatus)
    //     .value
    //     .toString()
    // );
    //
    // listTasks.add(task);
    // }),
    //
    // emit(TaskLoadedSuccessState(
    // listTasks))
    //
    // // .id).value.toString(),snapshot.child(AllUser().name).value.toString(),snapshot.child(AllUser().id).value.toString(),snapshot.child(AllUser().).value.toString())));
    // }
    // else
    // {
    // // = Profile(
    // //    "Not Found", "Not Found", "Not Found", "Not Found"),
    // emit(TaskNotFoundState()),
    // }
    // })
    //     .catchError((error) {
    // print('Failed to Load data: $error');
    // });
    // }
  }

  FutureOr<void> TaskViewedMethod(
      TaskViewedEvent event, Emitter<TaskState> emit) {

    print("ItemClicked Event"+event.taskId);
  }

  Future<FutureOr<void>> TaskUpdateMethod(
      TaskUpdateEvent event, Emitter<TaskState> emit) async {
    print("AddUser Event" + event.taskId);

    try {
      // Reference to the task document
      DocumentReference taskRef = FirebaseFirestore.instance.collection(AllTaskKeyCon().taskCon).doc(event.taskId);

      // Update the task's status
      await taskRef.update({
        AllTaskKeyCon().completeStatus: "1",
      });

      //for update locally
      // for(int i=0;i<listTasks.length;i++)
      //   if(listTasks[i].id==event.taskId)
      //     listTasks[i].completeStatus="1";


      print('Task status updated successfully');
      // reload data
      emit(TaskInitialState());
    } catch (e) {
      print('Failed to update task status: $e');
      emit(TaskShowErrorState("error Occured Please Try After some time"));
    }

    // Verify the user ID from the web that not acquire by any one

    // //Offline partner made will tamporary Id which doesn't have any user
    // await FirebaseDatabase.instance.ref().child(AllTask().taskCon).child(event.taskId).set({
    //   AllTask().completeStatus:"1",
    // }).then((_) {
    //
    // print('Task Updated successfully!');
    //
    //
    // }).catchError((error) {
    // print('Failed to store data: $error');
    // });


  }






  
}

//all events

@immutable
abstract class TaskEvent {}

//to take argument from event
class TaskInitialEvent extends TaskEvent {}

class TaskViewedEvent extends TaskEvent {
  final String taskId;

  TaskViewedEvent(this.taskId);
}

class TaskUpdateEvent extends TaskEvent {
  final String taskId;

  TaskUpdateEvent(this.taskId);
}




//all the states
@immutable
abstract class TaskState {}

class TaskInitialState extends TaskState {}

class TaskLoadingState extends TaskState {}

//for initial show,error showed and sucess data show
class TaskLoadedSuccessState extends TaskState {
  final List<Task> listTasks;


  // final Partner partner;

  TaskLoadedSuccessState( this.listTasks);
}

class TaskNotFoundState extends TaskState {}


class TaskShowErrorState extends TaskState {
  final String msg;

  TaskShowErrorState(this.msg);
}