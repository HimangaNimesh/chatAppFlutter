import 'package:firebase_auth/firebase_auth.dart';

class AuthService{
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //login

  //register
  Future registerUserWithEmailandPassword(String email, String password, String fullName)async{
    try{
      User user = (await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)).user!;

      if(user!= null){
        //call database service to update the user data
        return true;
      }
    }
    on FirebaseAuthException catch(e){

    }
  }

  //signout
}