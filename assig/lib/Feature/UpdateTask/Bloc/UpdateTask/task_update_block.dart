import 'dart:async';
import 'dart:ui';

import 'package:assig/KeyCon.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../DataStruct/Tasks.dart';

class TaskUpdateBloc extends Bloc<TaskUpdateEvent, TaskUpdateState> {
  //for default passing eanbility
  TaskUpdateBloc() : super(TaskUpdateInitialState()) {
    on<TaskUpdateInitialEvent>(TaskInitialMethod);
    on<TaskUpdateAddOrUpdateEvent>(TaskUpdateMethod);
  }
  @override
  void onChange(Change<TaskUpdateState> change) {
    // TODO: implement onChange
    print(change.currentState.toString()+" "+change.nextState.toString());
    super.onChange(change);
  }

  Task task = Task("id",'nothing','nothing','nothing','nothing','nothing','nothing');
  bool dataFound = false;
  String userId="";

  Future<FutureOr<void>> TaskInitialMethod(
      TaskUpdateInitialEvent event, Emitter<TaskUpdateState> emit) async {

    emit(TaskUpdateNotFoundState());
    // to get user id from local db
    FlutterSecureStorage _secureStorage = FlutterSecureStorage();
    // String? tamp = await _secureStorage.read(key: 'id');
    // userId=tamp!;

    task=event.task;

    if(task.id==""||task==null){
      dataFound=false;
      emit(TaskUpdateNotFoundState());
    }else{
      //fetch data and set data
      dataFound=true;
      emit(TaskUpdateLoadedSuccessState(task));

    }

  }





  Future<FutureOr<void>> TaskUpdateMethod(
      TaskUpdateAddOrUpdateEvent event, Emitter<TaskUpdateState> emit) async {
    print("AddUser Event" + event.task.toString());

    if(task==event.task){

      //check user update something or not
      //show Error message
      if(dataFound)
        emit(TaskUpdateShowErrorState("Please Update something"));
      else
        emit(TaskUpdateShowErrorState("Please Enter Details"));


      //show basic string
      //show empty states data
      if(dataFound)
        emit(TaskUpdateLoadedSuccessState(task));
      else
        emit(TaskUpdateNotFoundState());
    }else{

      //or storing data to local task
      task=event.task;

      //do db work

      //for new task id
      String id=DateTime.now().millisecondsSinceEpoch.toString();
      if(dataFound){
        //To update the data use pre id
        id=event.task.id;
        //store the data
        // Reference to Firestore collection
        try{
          await FirebaseFirestore.instance.collection(AllTaskKeyCon().taskCon).doc(id).update(
              {
                AllTaskKeyCon().title:task.title,
                AllTaskKeyCon().discription:task.discription,
                AllTaskKeyCon().completeStatus:"0",
                AllTaskKeyCon().deadLine:task.deadLine,
                AllTaskKeyCon().expectedCompTime:task.expectedCompTime,
                AllTaskKeyCon().ownerId:userId,
              }
          );

          //for scheduling notification
          var scheduledNotificationDateTime = DateTime.now().subtract(Duration(seconds: 5));

          //before 10 min
          scheuduleNotfication(DateTime.fromMicrosecondsSinceEpoch(int.parse(task.deadLine)).subtract(Duration(minutes: 10)));

          emit(TaskUpdateShowErrorState("Sucessfully Updated"));

        }catch(e){
          print("error occured");
          emit(TaskUpdateShowErrorState("Error Occured Please try Again"));
        }

      }else{

        //to store the new data
        // Reference to Firestore collection
        try{
          DocumentReference doc=await FirebaseFirestore.instance.collection(AllTaskKeyCon().taskCon).add(
              {
                AllTaskKeyCon().title:task.title,
                AllTaskKeyCon().discription:task.discription,
                AllTaskKeyCon().completeStatus:"0",
                AllTaskKeyCon().deadLine:task.deadLine,
                AllTaskKeyCon().expectedCompTime:task.expectedCompTime,
                AllTaskKeyCon().ownerId:userId,
              }
          );

          id=doc.id;

          emit(TaskUpdateShowErrorState("Sucessfully Stored"));

        }catch(e){
          print("error occured");
          emit(TaskUpdateShowErrorState("Error Occured Please try Again"));
        }

      }


      // Add user data to Firestore




      //
      // //Offline partner made will tamporary Id which doesn't have any user
      // await FirebaseDatabase.instance.ref().child(AllTask().taskCon).child(id).set({
      //   AllTask().ownerId:userId,
      //   AllTask().title:event.task.title,
      //   AllTask().discription:event.task.discription,
      //   AllTask().deadLine:event.task.deadLine,
      //   AllTask().expectedCompTime:event.task.expectedCompTime,
      //   AllTask().completeStatus:"0",
      //
      // }).then((_) {
      //
      //   print('Task Updated successfully!');
      //
      //   //go Back to tasks list
      //
      // }).catchError((error) {
      //   print('Failed to Update / add  data: $error');
      // });

      print("task updated sucessfull"+id);


    }


  }

  Future<void> scheuduleNotfication(var scheduledNotificationDateTime) async {
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin=FlutterLocalNotificationsPlugin();

      const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
          '', 'AssignmentChannel', 'Task Alert description',
          importance: Importance.max, priority: Priority.high, showWhen: false);
      const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.schedule(
          0,
          'Task deadline will crossing',
          'Complete the task hurry up',
          scheduledNotificationDateTime,
          platformChannelSpecifics);
  }




  
}

//all events

@immutable
abstract class TaskUpdateEvent {}

//to take argument from event
class TaskUpdateInitialEvent extends TaskUpdateEvent {
  final Task task;

  TaskUpdateInitialEvent(this.task);
}



class TaskUpdateAddOrUpdateEvent extends TaskUpdateEvent {
  final Task task;

  TaskUpdateAddOrUpdateEvent(this.task);
}




//all the states
@immutable
abstract class TaskUpdateState {}

class TaskUpdateInitialState extends TaskUpdateState {}


//for initial show,error showed and sucess data show
class TaskUpdateLoadedSuccessState extends TaskUpdateState {
  final Task task;


  // final Partner partner;

  TaskUpdateLoadedSuccessState( this.task);
}

class TaskUpdateNotFoundState extends TaskUpdateState {}
class TaskUpdateShowErrorState extends TaskUpdateState {
  final String msg;

  TaskUpdateShowErrorState(this.msg){
    print("Error Message:"+msg);

  }
}


