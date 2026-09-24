import 'package:flutter/material.dart';
import 'package:vitalo/app_states.dart';
import 'package:vitalo/create_donor_profile/eligibility.dart';
import 'package:vitalo/screens/create_profile.dart';

class DonorStatusBanner extends StatelessWidget {
  final VoidCallback onNavigateToProfile;

  const DonorStatusBanner({super.key, required this.onNavigateToProfile});

  @override
  Widget build(BuildContext context) {
    final nextEligible = DonorEligibility.nextEligibleDate(
      AppState.donorLastDonationOption,
      AppState.donorLastDonationDate,
    );
    final isEligible =
        nextEligible == null || nextEligible.isBefore(DateTime.now());

    if (AppState.isDonor) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFCD3024)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFCD3024),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFCD3024).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.bloodtype,
                color: Color(0xFFCD3024),
                size: 30,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Blood Group: ${AppState.donorBloodGroup ?? "Not set"}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: isEligible
                              ? Colors.green.shade50
                              : Colors.amber.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          isEligible ? 'Eligible' : 'Not Eligible',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isEligible
                                ? Colors.green.shade700
                                : Colors.amber.shade800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isEligible
                        ? 'You can donate blood and save lives today!'
                        : 'Next eligible: ${nextEligible.day}/${nextEligible.month}/${nextEligible.year}',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios, size: 16),
              color: const Color(0xFFCD3024),
              onPressed: onNavigateToProfile,
            ),
          ],
        ),
      );
    } else {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFFCD3024),
              const Color(0xFFCD3024).withValues(alpha: 0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFCD3024),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Become a Donor',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Register your profile & save lives in your neighborhood.',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreateProfile(),
                        ),
                      ).then((_) => onNavigateToProfile());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFFCD3024),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Register Now',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.volunteer_activism,
              size: 54,
              color: Colors.white24,
            ),
          ],
        ),
      );
    }
  }
}
