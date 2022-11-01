import 'package:firebase_core/firebase_core.dart';
import 'package:instagram_clone_app1/firebase_options.dart';

class AppSetup {
  static Future<void> get setup async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}