import 'package:time_tracker/src/models/user.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/src/screens/home/jobs/jobs_page.dart';
import 'package:time_tracker/src/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker/src/services/database.dart';
import '../screens/sign_in/sign_in_page.dart';



class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    return StreamBuilder<User>(
      stream: auth.onAuthStateChanged,
      builder: (context, AsyncSnapshot<User> snapshot) {
        if(snapshot.connectionState == ConnectionState.active ){
          User user = snapshot.data;
          if(user == null){
            return SignInPage.create(context);
          }
          return Provider<Database>(
            create:(_)=>FireStoreDatabase(uid: user.uid),
            child:JobsPage(),
          );
        }
        else{
          return Scaffold(
            body:Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
 