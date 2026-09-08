import 'package:flutter/material.dart';

class DatePickerField extends StatelessWidget {
  final String label;
  final DateTime? date;
  final VoidCallback onTap;

  const DatePickerField({
    super.key,
    required this.label,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.calendar_today_outlined),
          border: const OutlineInputBorder(),
        ),
        child: Text(
          date == null
              ? 'Select date'
              : '${date!.day}/${date!.month}/${date!.year}',
          style: TextStyle(
            color: date == null ? Colors.grey[600] : Colors.black,
          ),
        ),
      ),
    );
  }
}
