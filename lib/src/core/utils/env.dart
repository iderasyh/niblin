import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: 'lib/.env')
final class Env {
  @EnviedField(varName: 'FIREBASE_IOS_KEY', obfuscate: true)
  static final String firebaseIosKey = _Env.firebaseIosKey;

  @EnviedField(varName: 'FIREBASE_ANDROID_KEY', obfuscate: true)
  static final String firebaseAndroidKey = _Env.firebaseAndroidKey;

  @EnviedField(varName: 'FIREBASE_BROWSER_KEY', obfuscate: true)
  static final String firebaseBrowserKey = _Env.firebaseBrowserKey;
}
