import 'package:flutter/material.dart';
import 'package:vitalo/create_donor_profile/donor.dart';

class EligibleDonorsPage extends StatefulWidget {
  final String? initialBloodTypeFilter;

  const EligibleDonorsPage({super.key, this.initialBloodTypeFilter});

  @override
  State<EligibleDonorsPage> createState() => _EligibleDonorsPageState();
}

class _EligibleDonorsPageState extends State<EligibleDonorsPage> {
  late String _selectedBloodType;

  static const List<String> _bloodTypes = [
    'All',
    'A+',
    'A-',
    'B+',
    'B-',
    'O+',
    'O-',
    'AB+',
    'AB-',
  ];

  static final List<Donor> _allDonors = [
    Donor(name: 'Rafiq Ahmed', bloodType: 'A+', distanceKm: 1.2, age: 27),
    Donor(name: 'Nusrat Jahan', bloodType: 'O-', distanceKm: 2.8, age: 34),
    Donor(name: 'Kamal Hossain', bloodType: 'B+', distanceKm: 3.5, age: 22),
    Donor(name: 'Sadia Islam', bloodType: 'AB+', distanceKm: 4.1, age: 29),
    Donor(name: 'Tanvir Rahman', bloodType: 'O+', distanceKm: 5.0, age: 31),
    Donor(name: 'Mehedi Hasan', bloodType: 'A-', distanceKm: 2.1, age: 25),
    Donor(name: 'Farhana Akter', bloodType: 'B-', distanceKm: 3.8, age: 28),
    Donor(name: 'Zubair Hossain', bloodType: 'AB-', distanceKm: 6.2, age: 33),
  ];

  @override
  void initState() {
    super.initState();
    _selectedBloodType = widget.initialBloodTypeFilter ?? 'All';
  }

  List<Donor> get _filteredDonors {
    if (_selectedBloodType == 'All') {
      return _allDonors;
    }
    return _allDonors
        .where((donor) => donor.bloodType == _selectedBloodType)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredDonors;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Eligible Donors'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            color: Colors.grey.shade50,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: _bloodTypes.map((type) {
                  final isSelected = _selectedBloodType == type;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(
                        type,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: Colors.red,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected ? Colors.red : Colors.grey.shade300,
                        ),
                      ),
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedBloodType = type;
                          });
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const Divider(height: 1),

          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person_off_outlined,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No donors found for $_selectedBloodType',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final donor = filtered[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          leading: CircleAvatar(
                            backgroundColor: Colors.red.withValues(alpha: 0.1),
                            child: const Icon(Icons.person, color: Colors.red),
                          ),
                          title: Text(
                            donor.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text('${donor.age} years old'),
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  donor.bloodType,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '${donor.distanceKm} km away',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            _showDonorContactDialog(context, donor);
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showDonorContactDialog(BuildContext context, Donor donor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.red.withValues(alpha: 0.1),
              child: Text(
                donor.bloodType,
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(donor.name, style: const TextStyle(fontSize: 18)),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Age: ${donor.age} years old'),
            const SizedBox(height: 4),
            Text('Distance: ${donor.distanceKm} km away'),
            const SizedBox(height: 12),
            const Text(
              'Would you like to connect with this donor for your blood request?',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Contact request sent to ${donor.name}!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            icon: const Icon(Icons.phone, size: 16),
            label: const Text('Contact Donor'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
