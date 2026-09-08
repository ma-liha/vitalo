import 'package:flutter/material.dart';
import 'package:vitalo/create_donor_profile/eligibility.dart';

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
