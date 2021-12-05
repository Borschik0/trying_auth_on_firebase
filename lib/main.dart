import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:trying_auth_on_firebsae/authentication.dart';
import 'package:provider/provider.dart';

import 'sign_in_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      Provider<AuthenticationService?>(
        create: (_) => AuthenticationService(FirebaseAuth.instance),
      ),
      StreamProvider(
        create: (context) => context.read<AuthenticationService>().authStateChanges, initialData: null,
      )
    ],
    child: MaterialApp(
      home: AuthenticationWrapper()
    )
  ));
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();
    if(firebaseUser !=null){
      return HomePage();
    }else return SignInPage();
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(onPressed: (){
            context.read<AuthenticationService>().signOut();
          }, child: Text('Signed Out'))
        ],
      ),
    );
  }
}
