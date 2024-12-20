import 'package:flutter/material.dart';
import 'package:sistem_presensi/constant/page_const.dart';
import 'package:sistem_presensi/src/presentation/pages/camera_sign_up_page.dart';
import 'package:sistem_presensi/src/presentation/pages/notification_page.dart';
import 'package:sistem_presensi/src/presentation/pages/presence/presence_camera_page.dart';
import 'package:sistem_presensi/src/presentation/pages/presence/presence_preview_page.dart';
import 'package:sistem_presensi/src/presentation/pages/sign_in_page.dart';
import 'package:sistem_presensi/src/presentation/pages/sign_up_page.dart';

// Class for routing

class OnGenerateRoute {
  static Route<dynamic> route(RouteSettings settings) {
    final List<dynamic> args = ((settings.arguments ?? []) as List<dynamic>);

    switch (settings.name) {
      case PageConst.signInPage: {
        return materialBuilder(widget: const SignInPage());
      }
      case PageConst.signUpPage: {
        return materialBuilder(widget: const SignUpPage());
      }
      case PageConst.addPresencePage: {
        return materialBuilder(widget: const ErrorPage());
      }
      case PageConst.presenceCameraPage: {
        return materialBuilder(widget: PresenceCameraPage());
      }
      case PageConst.presencePreviewPage: {
        return materialBuilder(widget: const PresencePreviewPage());
      }
      case PageConst.notificationPage: {
        return materialBuilder(widget: const NotificationPage());
      }
      case PageConst.cameraSignUpPage: {
        return materialBuilder(widget: CameraSignUpPage(uid: args[0],));
      }
      default: {
        return materialBuilder(widget: const ErrorPage());
      }
    }

  }
}

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('error'),
      ),
      body: const Center(
        child: Text('error'),
      ),
    );
  }
}

MaterialPageRoute materialBuilder({required Widget widget}) {
  return MaterialPageRoute(builder: (_) => widget);
}