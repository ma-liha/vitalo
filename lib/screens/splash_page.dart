import 'package:flutter/material.dart';
import 'package:vitalo/services/auth_service.dart';
import 'package:vitalo/app_states.dart';
import 'home_page.dart';
import 'login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _dotAnimations;

  final double _dotHeight = 10;
  final double _minWidth = 10;
  final double _maxWidth = 26;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();

    _dotAnimations = List.generate(3, (index) {
      final double start = index * 0.2;
      final double end = start + 0.5;

      return TweenSequence<double>([
        TweenSequenceItem(
          tween: Tween(
            begin: _minWidth,
            end: _maxWidth,
          ).chain(CurveTween(curve: Curves.easeInOut)),
          weight: 50,
        ),
        TweenSequenceItem(
          tween: Tween(
            begin: _maxWidth,
            end: _minWidth,
          ).chain(CurveTween(curve: Curves.easeInOut)),
          weight: 50,
        ),
      ]).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(start, end, curve: Curves.linear),
        ),
      );
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;

      final user = AuthService().currentUser;
      final Widget targetScreen;

      if (user != null) {
        if (user.displayName != null && user.displayName!.isNotEmpty) {
          AppState.donorName = user.displayName;
        }
        targetScreen = const HomePage();
      } else {
        targetScreen = const LoginScreen();
      }

      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 800),
          pageBuilder: (context, animation, secondaryAnimation) =>
              targetScreen,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildDot(int index) {
    return AnimatedBuilder(
      animation: _dotAnimations[index],
      builder: (context, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Container(
            width: _dotAnimations[index].value,
            height: _dotHeight,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(_dotHeight / 2),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: AssetImage('images/logo.png'), width: 150),
            const SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) => _buildDot(index)),
            ),
          ],
        ),
      ),
    );
  }
}
