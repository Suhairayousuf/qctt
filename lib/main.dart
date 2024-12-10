 import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/Home/screens/contacts_page.dart';
import 'features/Home/screens/routing_page.dart';
import 'features/card/screens/add_card_page.dart';
import 'features/card/screens/card_page.dart';
import 'features/group/screens/add_group_page.dart';
import 'features/Home/screens/navigation_page.dart';
import 'features/Home/screens/home_page.dart';
import 'features/Home/screens/recent_call_log_page.dart';
import 'features/Home/screens/splash_screen.dart';
import 'features/group/screens/add_member_page.dart';
import 'features/group/screens/addmember_from_group.dart';
import 'features/group/screens/group_detailes_page.dart';
import 'features/user/screens/edit_user_data.dart';
import 'features/user/screens/user_single_page.dart';
import 'firebase_options.dart';
 var height;
 var width;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebase();
  // Set up Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  runApp(ProviderScope(child: const MyApp()));
}
 Future<void> initializeFirebase() async {
   try {
     // Check if Firebase is already initialized
     if (Firebase.apps.isEmpty) {
       await Firebase.initializeApp();
     }
   } catch (e) {
     print('Error initializing Firebase: $e');
   }
 }


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Named Routes ',
      initialRoute: '/RoutingPage', // The initial route when the app starts
      routes: {
         '/RoutingPage': (context) => RoutingPage(),
        '/SplashScreenWidget': (context) => SplashScreenWidget(),
        '/NavigationBarPage': (context) => NavigationBarPage(),
        '/HomePage': (context) => HomePage(),
        '/AddGroupPage': (context) => AddGroupPage(),
        '/GroupDetailesPage': (context) => GroupDetailesPage(),
        '/AddMemberPage': (context) => AddMemberPage(type: false, groupId: '',),
        '/UserSinglePage': (context) => UserSinglePage(),
         '/EditUserDetails': (context) => EditUserDetails(),
         '/ContactsPage': (context) => ContactsPage(),
         '/CallLogPage': (context) => CallLogPage(),
         '/CardPage': (context) => CardPage(),
         '/AddCardDetailsPage': (context) => AddCardDetailsPage(),
         '/AddMemberFromEditPage': (context) => AddMemberFromEditPage(type:false, groupId: '',),


      },
       // home:HomePage2(),
       home:SplashScreenWidget(),
    );
  }
}

