export 'features/_core/global_mediator.dart';

import 'package:app_links/app_links.dart';
import 'package:feature/core/core_language.dart';
import 'package:feature/core/core_ui.dart';
import 'package:feature/features/_core/auth_preserver_controller.dart';
import 'package:feature/features/_core/global_mediator.dart';
import 'package:feature/features/home/presentation/ui/post_details_screen.dart';
import 'package:flutter/material.dart';
import 'features/_navigation/pages_example.dart';
import 'features/auth/presentation/ui/login_screen.dart';
import 'features/home/presentation/ui/home_screen.dart';
class FeatureEntryPoint extends StatefulWidget {
  const FeatureEntryPoint({super.key});

  @override
  State<FeatureEntryPoint> createState() => _FeatureEntryPointState();
}

class _FeatureEntryPointState extends State<FeatureEntryPoint> {
  String? postId;
  @override
  void initState() {
    super.initState();
    deepLink();
  }



  void deepLink() async {
    final appLinks = AppLinks();
    final Uri? link = await appLinks.getInitialLink();
    if (link != null) {
      Logger.off("EntryPoint", 'deepLink: $link');
      final String? path = link.path;  // e.g., /post/1
      if (path != null && path.isNotEmpty) {
        final segments = path.split('/');  // Split the path into segments
        final String id = segments.last;
        Logger.off("EntryPoint", 'Extracted ID: $id');
        safeSetState((){
          postId=id;
        });
      } else {
        Logger.off("EntryPoint", 'No ID found in deep link path');
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Navigation2Sample();
    final id=postId;
    if(id==null){
      return BackHandlerDecorator(child: EntryPoint());
    }
    else {
      return BackHandlerDecorator(child: PostDetailsScreen(id,showBackAction: false));
    }

  }
}

class EntryPoint extends StatefulWidget {
  const EntryPoint({super.key});

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> {
  bool? isLoggedIn;


  @override
  void initState() {
    super.initState();
    AppMediator.setOnSessionExpire(() async {
      Logger.on("EntryPoint", 'onSessionExpire');
      AuthPreserverController.clear();
      safeSetState(() {
        isLoggedIn = null;
      });
      safeSetState(() {
        isLoggedIn = false;
      });
    });
    init();
  }



  void init() async {
    try {
      await delayInMs(1500);
      await AuthPreserverController.readAccessTokenOrThrow();
      safeSetState(() {
        isLoggedIn = true;
      });
    } catch (_) {
      safeSetState(() {
        isLoggedIn = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn == null)
    if (isLoggedIn == null) {
      return SplashScreen();
    }
    if (isLoggedIn == true) {
      return HomeScreen();
    } else {
      return LoginScreen(
        onLoginSuccess: () {
          safeSetState(() {
            isLoggedIn = true;
          });
        },
      );
    }
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue, // Background color for the splash screen
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.star,
              size: 100.0,
              color: Colors.white,
            ),
            SizedBox(height: 20),
            Text(
              'Welcome to Softmax',
              style: TextStyle(fontSize: 24.0, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
//