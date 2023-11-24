import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trenning/theme/theme_provider.dart';

import '../models/stateSwichButton.dart';


class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {

    StateSwich state = StateSwich(false);

    void stateButton() {
      state.checkState();
    }

   initState() {
    stateButton();
   }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text('Settings', style: Theme.of(context).primaryTextTheme.displayLarge!.copyWith(fontSize: 20),),
      ),
      body:  Center(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(15) ,
              width: MediaQuery.of(context).size.width,
             child: TextButton(
            onPressed: () {
             FirebaseAuth.instance.signOut();
              Navigator.pushNamedAndRemoveUntil(context, '/sign_in', (route) => false);
            },
            style: Theme.of(context).textButtonTheme.style,
            child: Text('Leave account', style: Theme.of(context).primaryTextTheme.displayLarge!.copyWith(fontSize: 14),)
             ),),
             Row(
               children: [
                 Padding(padding: EdgeInsets.all(15) ,),
                 Text('Light theme', style: Theme.of(context).primaryTextTheme.displayLarge!.copyWith(fontSize: 14),),
                 Semantics(
                  child: CupertinoSwitch(
                  activeColor: Theme.of(context).colorScheme.primary,
                  value: Global.shared.state.stateS, 
                  onChanged: (bool newState) async{
                     setState(() {
                 Global.shared.state.stateS = newState;
                     });       
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
                  },
                 ) ,
                 )
                 
                 
               ],
             )
          ],
        )
        ),
    );
    
  }
}
class Global{
 StateSwich state = StateSwich(false);
  
  static final shared = Global._();
  Global._();
}