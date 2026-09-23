import 'package:flutter/material.dart';
import 'package:vitalo/create_donor_profile/eligibility.dart';
import 'package:vitalo/services/auth_service.dart';
import 'package:vitalo/app_states.dart';
import 'login_page.dart';

class DonorProfilePage extends StatelessWidget {
  final String name;
  final String bloodGroup;
  final DateTime dateOfBirth;
  final String sex;
  final double hemoglobinLevel;
  final String address;
  final String? lastDonationOption;
  final DateTime? lastDonationDate;

  const DonorProfilePage({
    super.key,
    required this.name,
    required this.bloodGroup,
    required this.dateOfBirth,
    required this.sex,
    required this.hemoglobinLevel,
    required this.address,
    this.lastDonationOption,
    this.lastDonationDate,
  });

  @override
  Widget build(BuildContext context) {
    final age = DonorEligibility.calculateAge(dateOfBirth);
    final nextEligible = DonorEligibility.nextEligibleDate(
      lastDonationOption,
      lastDonationDate,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Donor Profile'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.red.withValues(alpha: 0.1),
                child: const Icon(Icons.person, size: 50, color: Colors.red),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Blood Group: $bloodGroup',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                nextEligible == null
                    ? 'Eligible to donate now'
                    : 'Next eligible: ${nextEligible.day}/${nextEligible.month}/${nextEligible.year}',
                style: TextStyle(
                  fontSize: 14,
                  color: nextEligible == null
                      ? Colors.green[700]
                      : Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: IntrinsicWidth(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _InfoRow(
                      icon: Icons.cake_outlined,
                      label: 'Age',
                      value: '$age years',
                    ),
                    _InfoRow(
                      icon: Icons.location_on_outlined,
                      label: 'Address',
                      value: address,
                    ),
                    _InfoRow(
                      icon: Icons.water_drop_outlined,
                      label: 'Hemoglobin Level',
                      value: '$hemoglobinLevel g/dL',
                    ),
                    _InfoRow(icon: Icons.wc_outlined, label: 'Sex', value: sex),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: OutlinedButton.icon(
                onPressed: () {
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
                      content: const Text(
                        'Are you sure you want to log out of Vitalo?',
                      ),
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
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Logged out successfully'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
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
                },
                icon: const Icon(Icons.logout_rounded, color: Colors.red),
                label: const Text(
                  'Log Out',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 32, child: Icon(icon, color: Colors.red)),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }
}
