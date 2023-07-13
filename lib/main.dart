// ignore_for_file: prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lit_starfield/view/lit_starfield_container.dart';
import 'package:market_place/authentication.dart';
import 'package:market_place/front_page.dart';

class MyApp extends StatelessWidget {
  @override
  
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<bool> checkUserExists(String email) async {
  List<String> signInMethods;
  
  try {
    signInMethods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
  } catch (e) {
    // Handle any errors that may occur during the request
    print('Error checking user: $e');
    return false;
  }
  
  return signInMethods.isNotEmpty;
}

  void _login(BuildContext context) async{
    if (_formKey.currentState!.validate()) {
      AuthService auth = AuthService();
      String username = _usernameController.text;
      String password = _passwordController.text;


      if(await checkUserExists(username)){
        auth.signIn(username, password);
        //Navigator.push(context,MaterialPageRoute(builder: (context) =>NFTBuyingPage(), ),);
      }
      else{
        auth.signUp(username,password);
        //Navigator.push(context,MaterialPageRoute(builder: (context) =>NFTBuyingPage(),),);
      }
      
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          child: Stack(
            children: [
      LitStarfieldContainer(
      animated: true,
      number: 500,
      velocity: 0.95,
      depth: 0.9,
      scale: 4,
      starColor: Colors.amber,
      backgroundDecoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 60, 56, 30),
            Color(0xFF791818),
            Color(0xFF284059),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
      ),
    ),
             
           Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 150,
                  height: 100,
                  
                  child: Image(
                    image: AssetImage("assets/images/logo.png")
                  ),
                ),
                SizedBox(height: 30),
                TextFormField(
                  controller: _usernameController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Username',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    errorBorder: OutlineInputBorder(
                       borderSide: BorderSide(color: Colors.white),
                    ),
                   focusedErrorBorder: OutlineInputBorder(
                       borderSide: BorderSide(color: Colors.white),
                    ),
                    errorStyle: TextStyle(
                      color: Colors.white, // Change the warning color here
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a username';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    errorBorder: OutlineInputBorder(
                       borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                       borderSide: BorderSide(color: Colors.white),
                    ),
                    errorStyle: TextStyle(
                      color: Colors.white, 
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {_login(context);},
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith((states) {
               
                if (states.contains(MaterialState.pressed)) {
                  return Colors.deepOrange;
                }
                return Colors.black;
              })),
                  child: Text('Sign Up',style: TextStyle(color: Colors.white),),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'Log In',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          ],),
        ),
      ),
    );
  }
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: AuthService().handleAuthState(),
  ));
}

