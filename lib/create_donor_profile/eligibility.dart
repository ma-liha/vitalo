class DonorEligibility {
  static int calculateAge(DateTime dob) {
    final today = DateTime.now();
    int age = today.year - dob.year;
    if (today.month < dob.month ||
        (today.month == dob.month && today.day < dob.day)) {
      age--;
    }
    return age;
  }

  static bool isEligible({
    required DateTime? dateOfBirth,
    required double weight,
    required double hemoglobinLevel,
    required String? sex,
  }) {
    if (dateOfBirth == null) return false;

    final age = calculateAge(dateOfBirth);
    final bool ageValid = age >= 18 && age <= 60;
    final bool weightValid = weight >= 45;

    bool hemoglobinValid;
    if (sex == 'Female') {
      hemoglobinValid = hemoglobinLevel >= 12;
    } else if (sex == 'Male') {
      hemoglobinValid = hemoglobinLevel >= 12.5 && hemoglobinLevel <= 13;
    } else {
      hemoglobinValid = hemoglobinLevel >= 12;
    }

    return ageValid && weightValid && hemoglobinValid;
  }

  static DateTime? nextEligibleDate(
    String? lastDonationOption,
    DateTime? lastDonationDate,
  ) {
    if (lastDonationOption == 'More than 4 months' ||
        lastDonationOption == null) {
      return null;
    }

    if (lastDonationOption == 'Less than 4 months' &&
        lastDonationDate != null) {
      return DateTime(
        lastDonationDate.year,
        lastDonationDate.month + 4,
        lastDonationDate.day,
      );
    }

    return null;
  }
}
