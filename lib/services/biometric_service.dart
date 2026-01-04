import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/foundation.dart';

class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();

  /// Check biometric availability
  Future<bool> isBiometricAvailable() async {
    try {
      final isSupported = await _auth.isDeviceSupported();
      final canCheck = await _auth.canCheckBiometrics;

      debugPrint('✅ Device supported: $isSupported');
      debugPrint('✅ Can check biometrics: $canCheck');

      return isSupported && canCheck;
    } on PlatformException catch (e) {
      debugPrint('❌ Biometric availability error: ${e.code}');
      return false;
    }
  }

  /// Authenticate user
  Future<bool> authenticate() async {
    try {
      debugPrint('🔐 Showing biometric prompt NOW');

      final authenticated = await _auth.authenticate(
        localizedReason: 'Authenticate to access Secure Vault',
        options: const AuthenticationOptions(
          biometricOnly: false, // Allow PIN fallback
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );

      debugPrint('🔐 Auth result: $authenticated');
      return authenticated;
    } on PlatformException catch (e) {
      debugPrint('❌ Auth failed: ${e.code} - ${e.message}');
      return false;
    }
  }
}
