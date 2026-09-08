import 'package:flutter/material.dart';
import 'package:vitalo/screens/create_request.dart';
import 'package:vitalo/screens/donor_list.dart';
import 'home_sheets.dart';

class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.15,
          children: [
            QuickActionCard(
              icon: Icons.person_search_rounded,
              title: 'Find Donors',
              subtitle: 'Nearby donors',
              color: Colors.red,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EligibleDonorsPage(),
                  ),
                );
              },
            ),
            QuickActionCard(
              icon: Icons.campaign_rounded,
              title: 'Request Blood',
              subtitle: 'Create request',
              color: Colors.blue,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateRequest(),
                  ),
                );
              },
            ),
            QuickActionCard(
              imageAsset: 'images/bloodBank.png',
              title: 'Blood Banks',
              subtitle: 'Verified centers',
              color: Colors.teal,
              onTap: () => HomeSheets.showBloodBanks(context),
            ),
            QuickActionCard(
              imageAsset: 'images/sos.png',
              title: 'Emergency SOS',
              subtitle: 'Call 999 / Helplines',
              color: Colors.deepOrange,
              onTap: () => HomeSheets.showEmergencySos(context),
            ),
          ],
        ),
      ],
    );
  }
}

class QuickActionCard extends StatelessWidget {
  final IconData? icon;
  final String? imageAsset;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const QuickActionCard({
    super.key,
    this.icon,
    this.imageAsset,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  }) : assert(icon != null || imageAsset != null);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: imageAsset != null
                  ? Image.asset(
                      imageAsset!,
                      width: 22,
                      height: 22,
                      fit: BoxFit.contain,
                    )
                  : Icon(icon, color: color, size: 22),
            ),
            const Spacer(),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
