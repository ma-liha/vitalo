import 'package:flutter/material.dart';
import 'package:vitalo/app_states.dart';
import 'package:vitalo/home_page/donor_status_banner.dart';
import 'package:vitalo/home_page/home_sheets.dart';
import 'package:vitalo/home_page/quick_actions_grid.dart';
import 'package:vitalo/home_page/quick_blood_finder.dart';
import 'package:vitalo/home_page/urgent_requests_section.dart';
import 'create_profile.dart';
import 'donor_profile.dart';

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
            padding: const EdgeInsets.only(right: 14.0, left: 4),
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

              DonorStatusBanner(onNavigateToProfile: _navigateToProfile),
              const SizedBox(height: 24),

              const QuickBloodFinder(),
              const SizedBox(height: 24),

              const QuickActionsGrid(),
              const SizedBox(height: 26),

              const UrgentRequestsSection(),
            ],
          ),
        ),
      ),
    );
  }
}
