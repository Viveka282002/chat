import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i_chat_instant/router/router.dart';
import 'package:i_chat_instant/screens/sender_info/controllers/sender_user_data_controller.dart';
import 'package:i_chat_instant/utils/common/providers/current_user_provider.dart';
import 'screens/home/screens/home_screen.dart';
import 'screens/landing/screens/landing_screen.dart';
import 'utils/common/screens/error_screen.dart';
import 'utils/common/screens/loading_screen.dart';
import 'utils/constants/string_constants.dart';
import 'utils/constants/theme_constants.dart';
 //import './models/user.dart'as app;
import './models/user.dart';

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: StringsConsts.appName,
      theme: appTheme,
      home: _getHomeWidget(ref),
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }

  Widget _getHomeWidget(WidgetRef ref) {
    // Watching senderUserDataAuthProvider for user data
    return LandingScreen();
    //   ref.watch(senderUserDataAuthProvider).when<Widget>(
    //   data: LandingScreen(),
    //
    //     //   (app.User? user) {
    //     // if (user == null) {
    //     //   return LandingScreen();
    //     // } else {
    //     //   // Handle authenticated user
    //     //   ref.read(currentUserProvider as ProviderListenable).state = user;
    //     //   return HomeScreen();
    //     // }
    //   },
    //   error: (error, stackTrace) {
    //     return ErrorScreen(
    //       error: error.toString(),
    //     );
    //   },
    //   loading: () => const LoadingScreen(),
    // );
  }
}
