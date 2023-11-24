
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../firebase_auth/firebase_auth_services.dart';

class signIn extends StatefulWidget {
  const signIn({super.key});

  @override
  State<signIn> createState() => _signInState();
}

class _signInState extends State<signIn> {

final FirebaseAuthServices _auth = FirebaseAuthServices();
TextEditingController _emailController = TextEditingController();
TextEditingController _passwordController = TextEditingController();

@override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
   //  var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
         Container(
        margin: EdgeInsets.all(15) ,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
             TextField(
            controller: _emailController,
            decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Email',
              ),
            ),
            const SizedBox(
            height: 7,
            ),
             TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Password',
              ),
            ),
          
             Container(
              margin: EdgeInsets.all(15) ,
              width: MediaQuery.of(context).size.width,
             child: TextButton(
            onPressed: _singInButton,
            child: Text('Login',  style: Theme.of(context).primaryTextTheme.displayLarge!.copyWith(fontSize: 14),),
            style: Theme.of(context).textButtonTheme.style,
             ),),
            RichText(
  text: TextSpan(
    children:[
     
       TextSpan(text: 'if you do not have an account,',
    style: Theme.of(context).primaryTextTheme.displayLarge!.copyWith(fontSize: 14), ),
      TextSpan(
    text: ' click here',
    style:  Theme.of(context).primaryTextTheme.displayLarge!.copyWith(fontSize: 14, color: Colors.blueAccent),
  recognizer: TapGestureRecognizer()..onTap = () {Navigator.pushNamedAndRemoveUntil(context, '/sign_up', (route) => false);}
)
    ],
  ),
)
          ],
        ),
          ),
        ],),
      ),
    );
  }
  void _singInButton() async {
      String email = _emailController.text;
      String password = _passwordController.text;
      User? user = await _auth.SignIpData(email, password);
      // ignore: unused_local_variable
      final uid = user?.uid;
      if(user != null){
      // ignore: use_build_context_synchronously
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      }else{
        print('error');
      }
  }
}