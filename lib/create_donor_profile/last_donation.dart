import 'package:flutter/material.dart';

class LastDonationField extends StatelessWidget {
  final String? selectedOption;
  final DateTime? selectedDate;
  final ValueChanged<String?> onOptionChanged;
  final VoidCallback onDateTap;

  const LastDonationField({
    super.key,
    required this.selectedOption,
    required this.selectedDate,
    required this.onOptionChanged,
    required this.onDateTap,
  });

  static const List<String> options = [
    'More than 4 months',
    'Less than 4 months',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          initialValue: selectedOption,
          decoration: const InputDecoration(
            labelText: 'Last Blood Donation',
            prefixIcon: Icon(Icons.history_outlined),
            border: OutlineInputBorder(),
          ),
          items: options.map((option) {
            return DropdownMenuItem(value: option, child: Text(option));
          }).toList(),
          onChanged: onOptionChanged,
          validator: (value) {
            if (value == null) {
              return 'Please select an option';
            }
            return null;
          },
        ),
        if (selectedOption == 'Less than 4 months') ...[
          const SizedBox(height: 16),
          InkWell(
            onTap: onDateTap,
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Date of Last Donation',
                prefixIcon: Icon(Icons.calendar_today_outlined),
                border: OutlineInputBorder(),
              ),
              child: Text(
                selectedDate == null
                    ? 'Select date'
                    : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                style: TextStyle(
                  color: selectedDate == null ? Colors.grey[600] : Colors.black,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
