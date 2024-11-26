 import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/Home/screens/contacts_page.dart';
import 'features/group/screens/add_group_page.dart';
import 'features/Home/screens/navigation_page.dart';
import 'features/Home/screens/home_page.dart';
import 'features/Home/screens/recent_call_log_page.dart';
import 'features/Home/screens/splash_screen.dart';
import 'features/group/screens/add_member_page.dart';
import 'features/group/screens/group_detailes_page.dart';
import 'features/group/screens/group_share_page.dart';
import 'features/user/screens/edit_user_data.dart';
import 'features/user/screens/user_single_page.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebase();
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
      initialRoute: '/SplashScreenWidget', // The initial route when the app starts
      routes: {
        '/SplashScreenWidget': (context) => SplashScreenWidget(),
        '/NavigationBarPage': (context) => NavigationBarPage(),
        '/HomePage': (context) => HomePage(),
        '/AddCardPage': (context) => AddCardPage(),
        '/GroupDetailesPage': (context) => GroupDetailesPage(),
        '/AddMemberPage': (context) => AddMemberPage(type: false, groupId: '',),
        '/UserSinglePage': (context) => UserSinglePage(),
         '/EditUserDetails': (context) => EditUserDetails(),
         '/GroupSharePage': (context) => GroupSharePage(),
         '/ContactsPage': (context) => ContactsPage(),
         '/CallLogPage': (context) => CallLogPage(),


      },
       // home:HomePage2(),
       home:SplashScreenWidget(),
    );
  }
}

