import 'package:flutter/material.dart';
import 'package:vitalo/app_states.dart';
import 'package:vitalo/home_page/donor_status_banner.dart';
import 'package:vitalo/home_page/home_sheets.dart';
import 'package:vitalo/home_page/quick_actions_grid.dart';
import 'package:vitalo/home_page/quick_blood_finder.dart';
import 'package:vitalo/home_page/urgent_requests_section.dart';
import 'create_profile.dart';
import 'donor_profile.dart';
import 'login_page.dart';
import 'package:vitalo/services/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _navigateToProfile() {
    if (AppState.isDonor && AppState.donorName != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DonorProfilePage(
            name: AppState.donorName!,
            bloodGroup: AppState.donorBloodGroup ?? 'Unknown',
            dateOfBirth: AppState.donorDateOfBirth ?? DateTime(2000, 1, 1),
            sex: AppState.donorSex ?? 'Other',
            hemoglobinLevel: AppState.donorHemoglobinLevel ?? 13.0,
            address: AppState.donorAddress ?? 'Not specified',
            lastDonationOption: AppState.donorLastDonationOption,
            lastDonationDate: AppState.donorLastDonationDate,
          ),
        ),
      ).then((_) => setState(() {}));
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CreateProfile()),
      ).then((_) => setState(() {}));
    }
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.logout_rounded, color: Colors.red),
            SizedBox(width: 8),
            Text('Log Out'),
          ],
        ),
        content: const Text('Are you sure you want to log out of Vitalo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await AuthService().signOut();
              AppState.isDonor = false;
              AppState.donorName = null;
              AppState.donorBloodGroup = null;
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Logged out successfully'),
                  duration: Duration(seconds: 2),
                ),
              );
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 205, 48, 36),
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: InkWell(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Location: Dhaka, Bangladesh'),
                duration: Duration(seconds: 1),
              ),
            );
          },
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.location_on, size: 18, color: Colors.white),
              SizedBox(width: 6),
              Text(
                'Dhaka, BD',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.white),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Badge(
              label: Text('2'),
              child: Icon(Icons.notifications_outlined, color: Colors.white),
            ),
            onPressed: () => HomeSheets.showNotifications(context),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 4.0, left: 4),
            child: GestureDetector(
              onTap: _navigateToProfile,
              child: const CircleAvatar(
                radius: 17,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 15,
                  backgroundImage: AssetImage('images/pfp.png'),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.white),
            tooltip: 'Log Out',
            onPressed: _confirmLogout,
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                'Ready to save a life today?',
                style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 20),

              // Donor Status / Register CTA Banner
              DonorStatusBanner(onNavigateToProfile: _navigateToProfile),
              const SizedBox(height: 24),

              // Quick Blood Finder Chips
              const QuickBloodFinder(),
              const SizedBox(height: 24),

              // 2x2 Quick Actions Dashboard Grid
              const QuickActionsGrid(),
              const SizedBox(height: 26),

              // Urgent Blood Requests Feed
              const UrgentRequestsSection(),
            ],
          ),
        ),
      ),
    );
  }
}
