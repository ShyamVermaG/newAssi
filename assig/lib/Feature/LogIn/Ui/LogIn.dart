import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Bloc/LogIn/login_block.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  LogInBloc logInBloc = LogInBloc();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState

    logInBloc.add(LogInInitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.grey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [

            Container(
              constraints: BoxConstraints(
                maxWidth: 400,
                maxHeight: 320
              ),

              height: double.infinity,
              width: double.infinity,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.all(Radius.circular(10))),

              child: BlocBuilder<LogInBloc, LogInState>(
                bloc: logInBloc,
                builder: (context, state) {
                  switch (state.runtimeType) {
                    case LogInInitialState:
                      return logInCustomWidget();

                    case LogInValidatingState:
                      return Center(
                        child: Text("Validating Data"),
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

          ],
        ),
      ),
    );
  }


  Widget logInCustomWidget(){
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[

          Text("LogIn/SignUp",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 30),),
          SizedBox(height: 44,),

          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(labelText: 'Email',contentPadding: EdgeInsets.only(left: 5)),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              // Add more validation if needed (e.g., regex for email format)
              return null;
            },
          ),
          TextFormField(
            controller: _passwordController,
            decoration:
            InputDecoration(labelText: 'Password',contentPadding: EdgeInsets.only(left: 5)),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
          ), SizedBox(height: 44),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(color: Colors.orange,borderRadius: BorderRadius.all(Radius.circular(10))),
            child: TextButton(onPressed: ()=>{

              logInBloc.add(LogInSubmitEvent(
                  _emailController.text.toString(),
                  _passwordController.text.toString())),

            }, child: Text("LogIn",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),)),
          ),
        ],
      ),
    );
  }

}
