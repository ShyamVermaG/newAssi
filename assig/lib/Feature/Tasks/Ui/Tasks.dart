import 'package:assig/Feature/Tasks/Bloc/Tasks/task_block.dart';
import 'package:assig/Feature/UpdateTask/Ui/Task_Update.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../DataStruct/Tasks.dart';


class TaskList extends StatefulWidget {
  const TaskList({super.key});

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  TaskBloc taskBloc = TaskBloc();

  @override
  void initState() {
    // TODO: implement initState

    taskBloc.add(TaskInitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(5),
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:[

                Text(
                  'Tasks',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                IconButton(icon:Icon(Icons.add),onPressed:()=>{
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TaskUpdate(task:Task("","","","","","",""))),
                ),

                },)
              ]
           
             
            ),

            Flexible(
              flex: 1,
              child: BlocBuilder<TaskBloc, TaskState>(
                bloc: taskBloc,
                builder: (context, state) {
                  switch (state.runtimeType) {
                    case TaskLoadedSuccessState:
                      final sucessState = state as TaskLoadedSuccessState;

                      return ListView.builder(
                        itemCount: sucessState.listTasks.length,
                        itemBuilder: (context, index) {
                          return   taskDataWidget(
                                  sucessState.listTasks[index]);


                        },
                      );

                    case TaskLoadingState:
                      return Center(
                        child: Text("Loading"),
                      );

                    default:
                      return Text(
                        "nothing",
                        style: TextStyle(color: Colors.grey, fontSize: 18),
                      );
                  }
                },
              ),
            ),

            //for all  text profile data
          ],
        ),
      ),
    );
  }




  Widget taskDataWidget(Task task) {
    return GestureDetector(
      onTap: (){
        taskBloc.add(TaskViewedEvent(task.id));

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TaskUpdate(task: task)),
        );
      },
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(

color: Colors.grey,

            borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        margin: EdgeInsets.only(left: 5,right: 5,top: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 100,
              height: 100,
              child: Icon(Icons.image,size: 95,),
            ),

            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    task.discription,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 18,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                         // Handle the result here
                        taskBloc.add(TaskUpdateEvent(task.id));

                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue, // Text color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        // Button border radius
                      ),
                    ),
                    child: Text('Completed',
                        style: TextStyle(color: Colors.white, fontSize: 14)),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        task.deadLine,
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                        ),
                      ),


                    ],
                  )
                ],
              ),
            ) // Button text
          ],
        ),
      ),
    );
  }
}
