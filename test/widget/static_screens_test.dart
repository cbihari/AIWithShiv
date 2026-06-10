import 'package:aiwithshiv/features/admin/presentation/admin_dashboard_screen.dart';
import 'package:aiwithshiv/features/onboarding/presentation/age_selection_screen.dart';
import 'package:aiwithshiv/features/onboarding/presentation/parent_consent_screen.dart';
import 'package:aiwithshiv/features/onboarding/presentation/welcome_screen.dart';
import 'package:aiwithshiv/features/parents/presentation/parent_dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Age selection renders learner groups', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: AgeSelectionScreen()));
    expect(find.text('Tiny Explorers'), findsOneWidget);
    expect(find.text('Adults'), findsOneWidget);
  });

  testWidgets('Parent consent renders consent action', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ParentConsentScreen()));
    expect(find.text('Parent Consent'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
  });

  testWidgets('Welcome screen renders primary action', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: WelcomeScreen()));
    expect(find.text('Build your AI superpowers'), findsOneWidget);
    expect(find.text('Start Learning'), findsOneWidget);
  });

  testWidgets('Parent dashboard renders MVP parent features', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ParentDashboardScreen()));
    expect(find.text('Progress Tracking'), findsOneWidget);
    expect(find.text('Weekly Email Reports'), findsOneWidget);
  });

  testWidgets('Admin dashboard renders MVP admin features', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: AdminDashboardScreen()));
    expect(find.text('Add Course'), findsOneWidget);
    expect(find.text('Analytics Dashboard'), findsOneWidget);
  });
}
