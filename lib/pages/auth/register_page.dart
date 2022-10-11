import 'package:chat_app/helper/helper_function.dart';
import 'package:chat_app/pages/auth/login_page.dart';
import 'package:chat_app/pages/home_page.dart';
import 'package:chat_app/service/auth_service.dart';
import 'package:chat_app/shared/constants.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String email = "";
  String password = "";
  String fullName = "";
  bool _isLoading = false;
  AuthService authService = AuthService();
  final formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading ? Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor,),) : SingleChildScrollView(
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
                const Text('Create an account to chat and explore', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),),
                const SizedBox(height: 25,),
                Image.asset('assets/SignUp.png'),
                TextFormField(
                  decoration: textInputDecoration.copyWith(
                      labelText: 'Full Name',
                      prefixIcon: Icon(Icons.person, color: Theme.of(context).primaryColor,)
                  ),
                  onChanged: (value){
                    setState(() {
                      fullName = value;
                    });
                  },
                  validator: (value){
                    if(value!.isNotEmpty){
                      return null;
                    }
                    else{
                      return "Name cannot be empty";
                    }
                  },
                ),
                const SizedBox(height: 10,),
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
                      register();
                    },
                    child: const Text('Register',
                      style: TextStyle(color: Colors.white, fontSize: 16),),
                  ),
                ),
                const SizedBox(height: 10,),
                Text.rich(
                    TextSpan(
                        text: "Already have an account?  ",
                        style: const TextStyle(color: Colors.black, fontSize: 14),
                        children: <TextSpan>[
                          TextSpan(
                              text: "Login now",
                              style: TextStyle(color: Theme.of(context).primaryColor),
                              recognizer: TapGestureRecognizer()..onTap = (){
                                nextScreen(context, const LoginPage());
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
  register() async{
    if(formkey.currentState!.validate()){
      setState(() {
        _isLoading = true;
      });
      await authService.registerUserWithEmailandPassword(email, password, fullName).then((value)async{
        if(value == true){
          //saving the shared preference state
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserNameSF(fullName);
          nextScreenReplacement(context, Homepage());
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
