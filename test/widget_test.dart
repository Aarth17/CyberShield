// CyberShield Security App Widget Test

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cybershield_security/main.dart';
import 'package:cybershield_security/models/vault_item.dart';

void main() {
  setUpAll(() async {
    // Initialize Hive for testing
    await Hive.initFlutter();
    Hive.registerAdapter(VaultItemAdapter());
  });

  testWidgets('CyberShield app launches successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(const CyberShieldApp());

    // Verify that the app title is displayed
    expect(find.text('CyberShield'), findsOneWidget);
    expect(find.text('Security Monitor'), findsOneWidget);

    // Verify that dashboard sections exist
    expect(find.text('Hardware Audit'), findsOneWidget);
    expect(find.text('Network Intel'), findsOneWidget);
  });
}