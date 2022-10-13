import 'package:chat_app/helper/helper_function.dart';
import 'package:chat_app/pages/auth/login_page.dart';
import 'package:chat_app/pages/profile_page.dart';
import 'package:chat_app/pages/search_page.dart';
import 'package:chat_app/service/auth_service.dart';
import 'package:chat_app/shared/constants.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String userName ="";
  String email = '';
  AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  gettingUserData()async{
    await HelperFunctions.getUserEmailFromSF().then((value){
      setState(() {
        email = value!;
      });
    });
    await HelperFunctions.getUserNameFromSF().then((val){
      setState(() {
        userName = val!;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text("Groups", style: const TextStyle(color: Colors.white),),
        backgroundColor: Theme.of(context).primaryColor,
        leading: Builder(
          builder: (context) => IconButton(
              onPressed: (){
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(Icons.menu, color: Colors.white,)),
        ),
        actions: [
          IconButton(
              onPressed: (){
                nextScreen(context, SearchPage());
              },
              icon: const Icon(Icons.search, color: Colors.white,))
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50),
          children: [
            Icon(Icons.account_circle, size: 150, color: Colors.grey[700],),
            const SizedBox(height: 15,),
            Text(userName, textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),),
            const SizedBox(height: 30,),
            const Divider(height: 2,),
            ListTile(
              onTap: (){},
              selectedColor: Theme.of(context).primaryColor,
              selected: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.group),
              title: const Text('Groups', style: TextStyle(color: Colors.black),),
            ),
            ListTile(
              onTap: (){
                nextScreenReplacement(context,  ProfilePage(email: email,userName: userName,));
              },
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.account_circle),
              title: const Text('Profile', style: TextStyle(color: Colors.black),),
            ),
            ListTile(
              onTap: ()async{
                showDialog(context: context, builder: (context){
                  return AlertDialog(
                    title: const Text('Logout'),
                    content: const Text('Are you sure you want to Logout?'),
                    actions: [
                      IconButton(onPressed: (){
                        Navigator.pop(context);
                      },
                          icon: const Icon(Icons.cancel, color: Colors.red,),
                      ),
                      IconButton(onPressed: ()async{
                        await authService.signOut();
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=> const LoginPage()),
                                (route) => false);
                      },
                          icon: const Icon(Icons.done, color: Colors.green,),
                      ),
                    ],
                  );
                });
              },
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.exit_to_app),
              title: const Text('LogOut', style: TextStyle(color: Colors.black),),
            ),
          ],
        ),
      ),
    );
  }
}
