import 'package:assig/KeyCon.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Task{
  String _id="nothing";
  String _ownerId="nothing";
  String _title="nothing";
  String _discription="nothing";
  String _deadLine="nothing";
  String _expectedCompTime="nothing";
  String _completeStatus="nothing";


  Task(this._id, this._title, this._discription, this._deadLine, this._ownerId,this._expectedCompTime,this._completeStatus);



  //for object comparison

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;


    return other is Task && other._id == _id && other._ownerId == _ownerId&& other._title == _title&& other._discription == _discription&& other._expectedCompTime == _expectedCompTime&& other._completeStatus == _completeStatus;
  }

  @override
  int get hashCode => _id.hashCode ^ _ownerId.hashCode^ _title.hashCode^ _discription.hashCode^ _deadLine.hashCode^ _expectedCompTime.hashCode^ _completeStatus.hashCode;




  //for getting data from firestore
  factory Task.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Task(doc.id,data[AllTaskKeyCon().title] ?? '',data[AllTaskKeyCon().discription] ?? '',data[AllTaskKeyCon().deadLine]?? "" ,data[AllTaskKeyCon().ownerId] ?? '',data[AllTaskKeyCon().expectedCompTime]?? "",data[AllTaskKeyCon().completeStatus]
    );
  }


  String get ownerId => _ownerId;

  set ownerId(String value) {
    _ownerId = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  String get title => _title;

  String get completeStatus => _completeStatus;

  set completeStatus(String value) {
    _completeStatus = value;
  }

  String get expectedCompTime => _expectedCompTime;

  set expectedCompTime(String value) {
    _expectedCompTime = value;
  }

  String get deadLine => _deadLine;

  set deadLine(String value) {
    _deadLine = value;
  }

  String get discription => _discription;

  set discription(String value) {
    _discription = value;
  }

  set title(String value) {
    _title = value;
  }

}