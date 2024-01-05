import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();


  Future<void> googleSignIn() async {
    try {
      String? clientIDA = _googleSignIn.clientId;
      Logger().i(
          "CURRENT BeforeLogin GoogleSignIn Object hosted domain:${_googleSignIn.hostedDomain.toString()}");
      Logger().i("CURRENT BeforeLogin scoped:${_googleSignIn.scopes}");
      Logger().i(
          "CURRENT BeforeLogin server Client ID:${_googleSignIn.serverClientId}");
      Logger().i(
          "CURRENT BeforeLogin serverClientID:${_googleSignIn.serverClientId}");

      if (clientIDA == null) {
        Logger().w("ClientIDA NULL");
      } else {
        Logger().w("ClientIDA  -- $clientIDA");
      }

      GoogleSignInAccount? gUSer = await _googleSignIn.signIn();

      Logger().d(
          "CURRENT AfterLogin GoogleSignIn Object hosted domain:${_googleSignIn.hostedDomain.toString()}");
      Logger().d("CURRENT AfterLogin scoped:${_googleSignIn.scopes}");
      Logger().d(
          "CURRENT AfterLogin server Client ID:${_googleSignIn.serverClientId}");

      if (gUSer == null) {
        Logger().e("GUSER NULL");
        return;
      }

      GoogleSignInAuthentication googleSignInAuthentication =
          await gUSer.authentication;
      Logger().f(
          "googleSignInAuthentication - access token: ${googleSignInAuthentication.accessToken}");
      Logger().f(
          "googleSignInAuthentication - id token: ${googleSignInAuthentication.idToken}");

      Logger().i("Login success");
      Logger().i("CURRENT USER email:${gUSer.email}");

      Map<String, dynamic> headers = await gUSer.authHeaders;
      for (var key in headers.keys) {
        Logger().w("HEADER KEY:$key-VALUE:${headers[key]}");
      }
      Logger().i("CURRENT USER displayName:${gUSer.displayName}");
      Logger().i("CURRENT USER id:${gUSer.id}");
      Logger().i("CURRENT USER photo url:${gUSer.photoUrl}");
      Logger().i("CURRENT USER server auth code:${gUSer.serverAuthCode}");

      String? clientID = _googleSignIn.clientId;
      if (clientID == null) {
        Logger().w("ClientID NULL");
      } else {
        Logger().w("ClientID -- $clientID");
      }
      Logger().i("Success ${gUSer.email}");
    } catch (e) {
      Logger().e("ERROR ${e.toString()}");
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Home"),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FloatingActionButton(
            onPressed: () async {
              await googleSignIn();
            },
            child: Icon(
              Icons.login,
            ),
          ),
          FloatingActionButton(
            onPressed: () async {
              await signOut();
            },
            child: Icon(
              Icons.logout,
            ),
          ),
        ],
      ),
    );
  }
}
