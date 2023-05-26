import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reminders_app/veiws/sign-up.dart';
import 'package:reminders_app/widgets/splash_screen.dart';
import 'widget_tree.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ScreenUtilInit(
      builder: (context, child) {
        return MaterialApp(
          title: 'Subtle Reminders',
          debugShowCheckedModeBanner: false,
          // home: WidgetTree(),
          home: SplashScreen(),
        );
      },
      designSize: const Size(393, 852),
    );
  }
}
