import 'package:chat_app/pages/auth/register_page.dart';
import 'package:chat_app/pages/home_page.dart';
import 'package:chat_app/service/auth_service.dart';
import 'package:chat_app/service/database_service.dart';
import 'package:chat_app/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../helper/helper_function.dart';
import '../../widgets/widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email = "";
  String password = "";
  bool _isLoading = false;
  AuthService authService = AuthService();
  final formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading ? Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor,),) :SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 80),
          child: Form(
            key: formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Text('Chatty', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),),
                const SizedBox(height: 15,),
                const Text('Login and chat with your friends', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),),
                const SizedBox(height: 25,),
                Image.asset('assets/LoginImage.png'),
                const SizedBox(height: 25,),
                TextFormField(
                  decoration: textInputDecoration.copyWith(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email, color: Theme.of(context).primaryColor,)
                  ),
                  onChanged: (value){
                    setState(() {
                      email = value;
                    });
                  },
                  validator: (value){
                    return RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value!)? null : "Please enter a valid email";
                  },
                ),
                const SizedBox(height: 10,),
                TextFormField(
                  obscureText: true,
                  decoration: textInputDecoration.copyWith(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock, color: Theme.of(context).primaryColor,)
                  ),
                  onChanged: (val){
                    setState(() {
                      password = val;
                    });
                  },
                  validator: (val){
                    if(val!.length<6){
                      return "Password must be at least 6 characters";
                    }
                    else{
                      return null;
                    }
                  },
                ),
                const SizedBox(height: 20,),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
                    ),
                    onPressed: (){
                      login();
                    },
                    child: const Text('Sign In',
                      style: TextStyle(color: Colors.white, fontSize: 16),),
                  ),
                ),
                const SizedBox(height: 10,),
                Text.rich(
                  TextSpan(
                    text: "Don't have an account? ",
                    style: const TextStyle(color: Colors.black, fontSize: 14),
                    children: <TextSpan>[
                      TextSpan(
                        text: "Register here",
                        style: TextStyle(color: Theme.of(context).primaryColor),
                        recognizer: TapGestureRecognizer()..onTap = (){
                          nextScreen(context, const RegisterPage());
                        }
                      )
                    ]
                  )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  login() async{
    if(formkey.currentState!.validate()){
      setState(() {
        _isLoading = true;
      });
      await authService.loginWithEmailandPassword(email, password).then((value)async{
        if(value == true){
          QuerySnapshot snapshot =
          await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
              .gettingUserData(email);
          //saving the values to our shared preferences
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserNameSF(
            snapshot.docs[0]['fullName']
          );
          nextScreenReplacement(context, const Homepage());
        }
        else{
          showSnackBar(context, value, Colors.red);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}
