import 'package:flutter/foundation.dart';
import '../services/biometric_service.dart';

class AuthProvider extends ChangeNotifier {
  final BiometricService _biometricService = BiometricService();

  bool _isVaultUnlocked = false;
  String lastError = '';

  bool get isVaultUnlocked => _isVaultUnlocked;

  Future<bool> checkBiometricAvailability() async {
    return await _biometricService.isBiometricAvailable();
  }

  Future<bool> authenticateUser() async {
    lastError = '';

    final available = await checkBiometricAvailability();
    if (!available) {
      lastError = 'Biometric authentication not available on this device.';
      notifyListeners();
      return false;
    }

    final success = await _biometricService.authenticate();

    if (success) {
      _isVaultUnlocked = true;
    } else {
      lastError = 'Authentication failed or cancelled.';
      _isVaultUnlocked = false;
    }

    notifyListeners();
    return success;
  }

  void lockVault() {
    _isVaultUnlocked = false;
    notifyListeners();
  }
}
