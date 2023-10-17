import 'package:elders_aid_project/providers/bookings_provider.dart';
import 'package:elders_aid_project/providers/status_provider.dart';
import 'package:elders_aid_project/providers/task_providers.dart';
import 'package:elders_aid_project/screens/Login_screens/Login_page.dart';
import 'package:elders_aid_project/screens/Login_screens/PasswordReset.dart';
import 'package:elders_aid_project/screens/Login_screens/Signup_page.dart';
import 'package:elders_aid_project/screens/Login_screens/splash_screen.dart';
import 'package:elders_aid_project/screens/admin_screens/admin_menu_page.dart';
import 'package:elders_aid_project/screens/elder_screens/completed_task.dart';
import 'package:elders_aid_project/screens/elder_screens/create_task.dart';
import 'package:elders_aid_project/screens/elder_screens/menuPage.dart';
import 'package:elders_aid_project/screens/elder_screens/my_task.dart';
import 'package:elders_aid_project/screens/elder_screens/profile_screen.dart';
import 'package:elders_aid_project/screens/elder_screens/review_screen.dart';
import 'package:elders_aid_project/screens/elder_screens/view_oldhouse.dart';
import 'package:elders_aid_project/screens/elder_screens/view_status.dart';
import 'package:elders_aid_project/screens/elder_screens/volunteers_details.dart';
import 'package:elders_aid_project/screens/oldhouse_screens/oldhouse_menu_page.dart';
import 'package:elders_aid_project/screens/volunteer_screen/booking_details.dart';
import 'package:elders_aid_project/screens/volunteer_screen/menu_page_volunteer.dart';
import 'package:elders_aid_project/screens/volunteer_screen/view_progress.dart';
import 'package:elders_aid_project/screens/volunteer_screen/view_task.dart';
import 'package:elders_aid_project/widgets/constants.dart';
import 'package:elders_aid_project/widgets/rides_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  User? currentFirebaseUser = FirebaseAuth.instance.currentUser;
  fAuth.currentUser != null
      ? AssistantMethods.readCurrentOnlineUserInfo()
      : null;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => RidesProvider()),
          ChangeNotifierProvider(create: (context) => MyTasksProvider()),
          ChangeNotifierProvider(create: (context) => BookingsProvider()),
          ChangeNotifierProvider(create: (context) => StatusProvider()),
          ChangeNotifierProvider(create: (context) => StatusProviderElder()),
          ChangeNotifierProvider(create: (context) => PastTasksProvider()),
          ChangeNotifierProvider(create: (context) => oldTasksProvider()),
          ChangeNotifierProvider(create: (context) => OldHouseProvider()),
        ],
        child: MaterialApp(
          // theme: ThemeData(brightness: Brightness.dark),
          debugShowCheckedModeBanner: false,
          // home: RideSharing(),
          initialRoute: SplashScreen.idScreen,
          routes: {
            SplashScreen.idScreen: (context) => SplashScreen(),
            LoginPage.idScreen: (context) => LoginPage(),
            ResetPage.idScreen: (context) => ResetPage(),
            SignUpPage.idScreen: (context) => SignUpPage(),
            MenuScreen.idScreen: (context) => MenuScreen(),
            MenuScreenVoulenteer.idScreen: (context) => MenuScreenVoulenteer(),
            CreateTask.idScreen: ((context) => CreateTask()),
            ViewTask.idScreen: ((context) => ViewTask()),
            MyTask.idScreen: ((context) => MyTask()),
            VolunteersDetail.idScreen: ((context) => VolunteersDetail()),
            ProgressDetail.idScreen: ((context) => ProgressDetail()),
            ProfileScreen.idScreen: ((context) => ProfileScreen()),
            BookingDetails.routeName: (context) => BookingDetails(),
            ViewStatusDetail.idScreen: (context) => ViewStatusDetail(),
            ViewStatusDetail.idScreen: (context) => ViewStatusDetail(),
            RateDriverScreen.idScreen: (context) => RateDriverScreen(),
            CompletedTask.idScreen: (context) => CompletedTask(),
            PostScreen.idScreen: (context) => PostScreen(),
            OldHouseMenuPage.idScreen: (context) => OldHouseMenuPage(),
            ViewOldHouse.idScreen: (context) => ViewOldHouse()
          },
        ));
  }
}
