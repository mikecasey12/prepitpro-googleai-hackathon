import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:prepitpro/db/recents.dart';
import 'package:prepitpro/helpers/db_init.dart';
import 'package:prepitpro/helpers/messenger.dart';
import 'package:prepitpro/models/user.dart';
import 'package:prepitpro/pages/auth/auth.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

abstract class AuthManager {
  static Future<void> signUserOut(BuildContext context) async {
    Messenger.showLoader(context);
    DBInit.supabase.auth.signOut().then((_) {
      Navigator.pop(context);
      Navigator.pushReplacementNamed(context, AuthPage.routeName);
    });
  }

  static final List<String> _scopes = <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
    "https://www.googleapis.com/auth/user.gender.read",
    "https://www.googleapis.com/auth/userinfo.email"
  ];

  static Future<void> signInWithOAuth() async {
    try {
      // const webClientId = Env.GOOGLE_WEB_CLIENT_ID;
      // const iosClientId = 'my-ios.apps.googleusercontent.com';

      final GoogleSignIn googleSignIn =
          GoogleSignIn(scopes: _scopes, signInOption: SignInOption.standard);

      final googleUser = await googleSignIn.signIn();
      final googleAuth = await googleUser!.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null) {
        throw 'No Access Token found.';
      }
      if (idToken == null) {
        throw 'No ID Token found.';
      }

      Map<String, dynamic> decodedToken = JwtDecoder.decode(idToken);
      debugPrint(decodedToken.toString());
      await DBInit.supabase.auth.signInWithIdToken(
          provider: sb.OAuthProvider.google,
          idToken: idToken,
          accessToken: accessToken);
    } catch (e) {
      rethrow;
    }
  }
}

class CurrentUser with ChangeNotifier {
  CurrentUser() {
    retrieveUser();
  }

  User _user = const User();

  User get user => _user;

  Future<void> retrieveUser() async {
    final currentUser = DBInit.supabase.auth.currentUser;
    final cu = User(
        id: currentUser!.id,
        email: currentUser.userMetadata!["email"],
        fname: currentUser.userMetadata!["fname"],
        gender: currentUser.userMetadata!["gender"],
        lname: currentUser.userMetadata!["lname"],
        userClass: currentUser.userMetadata!["userClass"],
        username: currentUser.userMetadata!["username"],
        avatar: currentUser.userMetadata!["avatar"],
        lastSignIn: currentUser.lastSignInAt,
        joinDate: currentUser.createdAt,
        points: currentUser.userMetadata!["points"],
        phonenum: currentUser.userMetadata!["phonenum"],
        subscribed: currentUser.userMetadata!["subscribed"] ?? false);
    _user = cu;
    notifyListeners();
  }

  Future<void> giveUserDailyPoint() async {
    final currentUser = DBInit.supabase.auth.currentUser;
    if (currentUser == null) {
      return;
    }
    final datePointGiven = currentUser.userMetadata!["datePointsGiven"];
    final today = DateTime.timestamp();
    final points = currentUser.userMetadata!["points"];
    if (datePointGiven != null) {
      final lastPointGivenDate =
          DateTime.tryParse(currentUser.userMetadata!["datePointsGiven"]);
      if (lastPointGivenDate!.isBefore(today)) {
        final data = {
          "datePointsGiven":
              today.add(const Duration(days: 1)).toIso8601String(),
          "points": points + 10
        };
        await updateUser(data);
      } else {
        debugPrint("Points not Given. Wait till next day.");
      }
    } else {
      final data = {
        "datePointsGiven": today.add(const Duration(days: 1)).toIso8601String(),
        "points": points != null ? points + 10 : 10
      };
      await updateUser(data);
    }
  }

  Future<void> signUserOut(BuildContext context) async {
    try {
      await DBInit.supabase.auth.signOut();
      _user = const User();
      if (context.mounted) {
        context.read<Recents>().reset();
      }
    } catch (_) {
      rethrow;
    }
    notifyListeners();
  }

  Future<void> updateUser(Map<String, dynamic> data) async {
    try {
      final userdata = DBInit.supabase.auth.currentUser!.userMetadata;
      await DBInit.supabase.auth
          .updateUser(sb.UserAttributes(data: {...userdata!, ...data}));
      await retrieveUser();
    } catch (_) {
      rethrow;
    }
    notifyListeners();
  }

  Future<void> changeUserPassword(String password) async {
    try {
      await DBInit.supabase.auth
          .updateUser(sb.UserAttributes(password: password));
    } catch (_) {
      rethrow;
    }
  }
}
