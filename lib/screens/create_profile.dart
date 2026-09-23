import 'package:flutter/material.dart';
import 'donor_profile.dart';

import 'package:vitalo/create_donor_profile/eligibility.dart';
import 'package:vitalo/create_donor_profile/last_donation.dart';
import 'package:vitalo/app_states.dart';

import 'package:vitalo/create_profile_info/app_text_field.dart';
import 'package:vitalo/create_profile_info/app_dropdown_field.dart';
import 'package:vitalo/create_profile_info/date_picker_field.dart';
import 'package:vitalo/create_profile_info/validators.dart';

class CreateProfile extends StatefulWidget {
  const CreateProfile({super.key});

  @override
  State<CreateProfile> createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ironLevelController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String? _selectedBloodGroup;
  String? _selectedSex;
  DateTime? _dateOfBirth;

  String? _lastDonationOption;
  DateTime? _lastDonationDate;

  static const _bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];

  static const _sexOptions = ['Male', 'Female', 'Other'];

  @override
  void dispose() {
    _nameController.dispose();
    _ironLevelController.dispose();
    _weightController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickDate({
    required DateTime initialDate,
    required DateTime firstDate,
    required ValueChanged<DateTime> onPicked,
  }) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: DateTime.now(),
    );
    if (picked != null) onPicked(picked);
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    if (_dateOfBirth == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select your date of birth')),
      );
      return;
    }

    final weight = double.tryParse(_weightController.text) ?? 0;
    final ironLevel = double.tryParse(_ironLevelController.text) ?? 0;

    final eligible = DonorEligibility.isEligible(
      dateOfBirth: _dateOfBirth,
      weight: weight,
      hemoglobinLevel: ironLevel,
      sex: _selectedSex,
    );

    if (!eligible) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You are not eligible to be a donor'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    AppState.isDonor = true;
    AppState.donorName = _nameController.text;
    AppState.donorBloodGroup = _selectedBloodGroup;
    AppState.donorDateOfBirth = _dateOfBirth;
    AppState.donorSex = _selectedSex;
    AppState.donorHemoglobinLevel = ironLevel;
    AppState.donorAddress = _addressController.text;
    AppState.donorLastDonationOption = _lastDonationOption;
    AppState.donorLastDonationDate = _lastDonationDate;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => DonorProfilePage(
          name: _nameController.text,
          bloodGroup: _selectedBloodGroup!,
          dateOfBirth: _dateOfBirth!,
          sex: _selectedSex!,
          hemoglobinLevel: ironLevel,
          address: _addressController.text,
          lastDonationOption: _lastDonationOption,
          lastDonationDate: _lastDonationDate,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Donor Profile'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              AppTextField(
                controller: _nameController,
                label: 'Name',
                icon: Icons.person_outline,
                validator: requiredValidator('Please enter your name'),
              ),
              const SizedBox(height: 16),

              AppDropdownField(
                value: _selectedBloodGroup,
                label: 'Blood Group',
                icon: Icons.bloodtype_outlined,
                items: _bloodGroups,
                onChanged: (value) =>
                    setState(() => _selectedBloodGroup = value),
                validator: requiredValidator('Please select your blood group'),
              ),
              const SizedBox(height: 16),

              DatePickerField(
                label: 'Date of Birth',
                date: _dateOfBirth,
                onTap: () => _pickDate(
                  initialDate: DateTime(2000),
                  firstDate: DateTime(1940),
                  onPicked: (date) => setState(() => _dateOfBirth = date),
                ),
              ),
              const SizedBox(height: 16),

              AppDropdownField(
                value: _selectedSex,
                label: 'Sex',
                icon: Icons.wc_outlined,
                items: _sexOptions,
                onChanged: (value) => setState(() => _selectedSex = value),
                validator: requiredValidator('Please select your sex'),
              ),
              const SizedBox(height: 16),

              AppTextField(
                controller: _ironLevelController,
                label: 'Hemoglobin Level (g/dL)',
                icon: Icons.water_drop_outlined,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: numberValidator(
                  'Please enter your hemoglobin level',
                ),
              ),
              const SizedBox(height: 16),

              AppTextField(
                controller: _weightController,
                label: 'Weight (kg)',
                icon: Icons.monitor_weight_outlined,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: numberValidator('Please enter your weight'),
              ),
              const SizedBox(height: 16),

              LastDonationField(
                selectedOption: _lastDonationOption,
                selectedDate: _lastDonationDate,
                onOptionChanged: (value) {
                  setState(() {
                    _lastDonationOption = value;
                    if (value != 'Less than 4 months') {
                      _lastDonationDate = null;
                    }
                  });
                },
                onDateTap: () => _pickDate(
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  onPicked: (date) => setState(() => _lastDonationDate = date),
                ),
              ),
              const SizedBox(height: 16),

              AppTextField(
                controller: _addressController,
                label: 'Address',
                icon: Icons.location_on_outlined,
                maxLines: 2,
                validator: requiredValidator('Please enter your address'),
              ),
              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Submit', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
