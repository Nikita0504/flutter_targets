import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:trenning/firebase_auth/firebase_auth_services.dart';

class signUp extends StatefulWidget {
  const signUp({super.key});

  @override
  State<signUp> createState() => _signUpState();
}

class _signUpState extends State<signUp> {


final FirebaseAuthServices _auth = FirebaseAuthServices();
String lableTextRepeatPassword = 'Repeat password';
TextEditingController _emailController = TextEditingController();
TextEditingController _passwordController = TextEditingController();
TextEditingController _repeatPassowrdController = TextEditingController();

@override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
         Container(
        margin: const EdgeInsets.all(15) ,
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
          const SizedBox(
            height: 7,
            ),
             TextField(
            controller: _repeatPassowrdController,
            obscureText: true,
            decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: lableTextRepeatPassword,
              ),
            ),
           
            Container(
              margin: EdgeInsets.all(15) ,
              width: MediaQuery.of(context).size.width,
             child: TextButton(
            onPressed: _singUp,
            style: Theme.of(context).textButtonTheme.style,
            child: Text('create', style: Theme.of(context).primaryTextTheme.displayLarge!.copyWith(fontSize: 14),),
             ),),
          
     RichText(
  text: TextSpan(
    children:[
     
       TextSpan(text: 'if you have an account,',
    style: Theme.of(context).primaryTextTheme.displayLarge!.copyWith(fontSize: 14), ),
      TextSpan(
    text: ' click here',
    style: Theme.of(context).primaryTextTheme.displayLarge!.copyWith(fontSize: 14, color: Colors.blueAccent),
  recognizer: TapGestureRecognizer()..onTap = () {Navigator.pushNamedAndRemoveUntil(context, '/sign_in', (route) => false);}
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
  void _singUp() async {
    if(_passwordController.text != _repeatPassowrdController.text){
      setState(() {
        lableTextRepeatPassword = "Password mismatch";
      });
    }else{
      String email = _emailController.text;
      String password = _passwordController.text;
      User? user = await _auth.SignUpData(email, password);
      final uid = user?.uid;
     // String uid = Credential.user.uid;
      setState(() {
        lableTextRepeatPassword = 'Repeat password';
      });

      if(user != null){
        // ignore: use_build_context_synchronously
        FirebaseFirestore.instance.collection('Users').doc(uid).set({});
        Navigator.pushNamedAndRemoveUntil(context, '/sign_in', (route) => false);
      }else{
        print('error');
      }

    }
  }
}