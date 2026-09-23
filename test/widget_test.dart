import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vitalo/screens/home_page.dart';
import 'package:vitalo/screens/login_page.dart';
import 'package:vitalo/screens/signup_page.dart';

void main() {
  testWidgets('HomePage smoke, modal sheets and navigation test',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() => tester.view.reset());

    await tester.pumpWidget(
      const MaterialApp(
        home: HomePage(),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Verify key home page dashboard elements are rendered
    expect(find.text('Dhaka, BD'), findsOneWidget);
    expect(find.text('Quick Blood Finder'), findsOneWidget);
    expect(find.text('Quick Actions'), findsOneWidget);
    expect(find.text('Find Donors'), findsOneWidget);
    expect(find.text('Request Blood'), findsOneWidget);
    expect(find.text('Blood Banks'), findsOneWidget);
    expect(find.text('Emergency SOS'), findsOneWidget);
    expect(find.text('Urgent Blood Requests'), findsOneWidget);

    // 2. Verify tapping on Find Donors navigates to EligibleDonorsPage
    await tester.tap(find.text('Find Donors'));
    await tester.pumpAndSettle();

    expect(find.text('Eligible Donors'), findsOneWidget);

    // Navigate back to Home
    await tester.pageBack();
    await tester.pumpAndSettle();

    // 3. Test opening Blood Banks sheet
    await tester.tap(find.text('Blood Banks'));
    await tester.pumpAndSettle();

    expect(find.text('Nearby Blood Banks'), findsOneWidget);
    expect(find.text('Bangladesh Red Crescent Blood Center'), findsOneWidget);

    // Close the sheet
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();

    // 4. Test opening Emergency SOS sheet
    await tester.tap(find.text('Emergency SOS'));
    await tester.pumpAndSettle();

    expect(find.text('Emergency SOS & Helplines'), findsOneWidget);
    expect(find.text('999'), findsOneWidget);

    // Close sheet via Navigator
    Navigator.of(tester.element(find.text('Emergency SOS & Helplines'))).pop();
    await tester.pumpAndSettle();

    // 5. Test Quick Blood Finder 'A+' chip navigation
    final aPlusChip = find.widgetWithText(ActionChip, 'A+');
    expect(aPlusChip, findsOneWidget);
    await tester.tap(aPlusChip);
    await tester.pumpAndSettle();

    expect(find.text('Eligible Donors'), findsOneWidget);
    expect(find.text('Rafiq Ahmed'), findsOneWidget);

    // Navigate back to Home
    await tester.pageBack();
    await tester.pumpAndSettle();

    // 6. Test Request Blood navigation
    await tester.tap(find.text('Request Blood'));
    await tester.pumpAndSettle();

    expect(find.text('Create Donation Request'), findsOneWidget);
  });

  testWidgets('LoginScreen renders red Vitalo title, forgot password and sign up',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() => tester.view.reset());

    await tester.pumpWidget(
      const MaterialApp(
        home: LoginScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Vitalo'), findsOneWidget);
    expect(find.text('Forgot Password?'), findsOneWidget);
    expect(find.text('Sign Up'), findsOneWidget);

    // Test tapping forgot password opens dialog
    await tester.tap(find.text('Forgot Password?'));
    await tester.pumpAndSettle();

    expect(find.text('Reset Password'), findsOneWidget);
    expect(find.text('Send Link'), findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(find.text('Reset Password'), findsNothing);

    // Test tapping Sign Up navigates to SignupScreen
    await tester.tap(find.text('Sign Up'));
    await tester.pumpAndSettle();

    expect(find.text('Create an Account'), findsOneWidget);
    expect(find.text('Full Name'), findsOneWidget);
    expect(find.text('Email Address'), findsOneWidget);
    expect(find.text('Blood Group'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Confirm Password'), findsOneWidget);

    // Test tapping Log In navigates back to LoginScreen
    await tester.tap(find.text('Log In'));
    await tester.pumpAndSettle();

    expect(find.text('Vitalo'), findsOneWidget);
  });

  testWidgets('SignupScreen validates empty form fields',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() => tester.view.reset());

    await tester.pumpWidget(
      const MaterialApp(
        home: SignupScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // Tap Sign Up with empty form
    await tester.tap(find.widgetWithText(ElevatedButton, 'Sign Up'));
    await tester.pumpAndSettle();

    expect(find.text('Please enter your full name'), findsOneWidget);
    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please select your blood group'), findsOneWidget);
    expect(find.text('Please enter your password'), findsOneWidget);
    expect(find.text('Please confirm your password'), findsOneWidget);
  });
}
