import 'dart:async';

import 'package:assig/KeyCon.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LogInBloc extends Bloc<LogInEvent, LogInState> {
  //for default passing eanbility
  LogInBloc() : super(LogInInitialState()) {
    on<LogInInitialEvent>(LogInInitialMethod);
    on<LogInSubmitEvent>(LogInSubmitMethod);
  }

  @override
  void onChange(Change<LogInState> change) {
    // TODO: implement onChange
    super.onChange(change);
    print(change.currentState.toString() + ":" + change.nextState.toString());
  }

  bool dataFound = true;
  String userId = "sdf";
  FlutterSecureStorage _secureStorage= FlutterSecureStorage();

  FutureOr<void> LogInInitialMethod(
      LogInEvent event, Emitter<LogInState> emit) async {


    //show initial State
    emit(LogInInitialState());


    String? tamp = await _secureStorage.read(key: 'id');
    userId = tamp!;

    //checkk already login or not

    if (tamp != null && tamp != "" && tamp.isNotEmpty) {
      //goto TaskLists
      emit(LogInErrorMsgState("Already Logged In"));
    }

    // Nothing to do
  }

  Future<FutureOr<void>> LogInSubmitMethod(
      LogInSubmitEvent event, Emitter<LogInState> emit) async {
    print("ItemClicked Event" +
        event.gmailId.toString() +
        "" +
        event.password.toString());


    //default screen
    emit(LogInValidatingState());

    //if failed it will return null and stop execution with showing a message

    //validate email and password login
    if(event.gmailId==null||event.gmailId.isEmpty){
      emit(LogInErrorMsgState("Please Enter Email"));
      return null;
    }
    if(event.password==null||event.password.isEmpty){
      emit(LogInErrorMsgState("Please Enter Password"));
      return null;
    }



    //check email already exists


    //firebase authentication with email password
    bool check=await SignInUsingFirebaseAuth(event.gmailId,event.password);

    //if check error occured or not
    //if failed it will return null and stop execution with showing a message
    if( ! check){
      return null;
    }

    //else go Forward





    // store data on Database and return id ,if not exists, if exist return id
    //if failed  return empty string and showing a message
    String userIdT=await CheckUserAccountFirestore(event.gmailId);

    //retunr null if not loggedIN
    if(userIdT==""||userIdT.isEmpty){
      return null;
    }

    //store data local database
    await _secureStorage.write(key: 'id',value: userIdT);

    //sucessful login
    //goto home page
    print('All Authentication goes sucesfull');
  }




  //this function will return userId if it goes sucesssfull
  //else retunr and empty string and set state to show error message
  Future<String> CheckUserAccountFirestore(String gmailId) async {

    String userId="";

    try {

      //check for user exists or not

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection(AllUserKeyCon().userCon).where(AllUserKeyCon().gamilId, isEqualTo: gmailId).get();

      if (querySnapshot.docs.isNotEmpty) {

        //if yes save userId returrn
        userId=querySnapshot.docs.first.id;

        return userId;

        // _statusMessage = 'User found: ${_userData?['name']}';

      } else {

        //if user not found wiht email
        //save user data
        try {
          // Reference to Firestore collection
          CollectionReference users = FirebaseFirestore.instance.collection('users');

          // Add user data to Firestore
          DocumentReference doc=await users.add({
            'email': gmailId,
          });


          //data stored sucess return document id
          //return user id
          userId=doc.id;
          return userId;

          //Navigate to another activity

        } catch (e) {
          //shwo message
          emit(LogInErrorMsgState(e.toString()));
        }

      }
    } catch (e) {
      //shwo message
      emit(LogInErrorMsgState(e.toString()));
      // _statusMessage = 'Error: $e';
      // _userData = null;
    }


    //return empty string
    return userId;

  }


  //this method will return false if error occur with showing message
  //else return true
  Future<bool> SignInUsingFirebaseAuth(String gmailId,String password) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;


    //check user already registered or not
    final signInMethods = await _auth.fetchSignInMethodsForEmail(gmailId);
    if(signInMethods.isEmpty){

      //register User
      try {
        final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: gmailId,
          password: password,
        );
        print("sucess full Registered");

        return true;
        // return userCredential.user;
      } on FirebaseAuthException catch (e) {
        print('Failed with error code: ${e.code}');
        print(e.message);

        //show message return false
        emit(LogInErrorMsgState("Error:"+e.message.toString()));
        return false;

        // return null;
      }
    }else{
      //LogIn User
      try {
        await _auth.signInWithEmailAndPassword(
          email: gmailId,
          password: password,
        );

        //sucessfull login
        print("Sucessfully LogedIn");
        return true;
      } on FirebaseAuthException catch (e) {
        emit(LogInErrorMsgState("InValid Email Password"));

        print('Failed with error code: ${e.code}');
        print(e.message);


        //show message return false
        emit(LogInErrorMsgState("Error:"+e.message.toString()));
        return false;

        // return null;
      }
    }

    //if nothig is happened retunr false;
    return false;
  }

}

//all events

@immutable
abstract class LogInEvent {}

//to take argument from event
class LogInInitialEvent extends LogInEvent {}

class LogInSubmitEvent extends LogInEvent {
  final String gmailId;
  final String password;

  LogInSubmitEvent(this.gmailId, this.password);
}

//all the states
@immutable
abstract class LogInState {}

class LogInInitialState extends LogInState {}

class LogInValidatingState extends LogInState {}

//for initial show,error showed and sucess data show
class LogInErrorMsgState extends LogInState {
  final String msg;

  // final Partner partner;

  LogInErrorMsgState(this.msg);
}
