class Doctor {
  final String name;
  final String specialization;
  final String experience;
  final double rating;
  final int fee;
  final bool isAvailable;

  Doctor({
    required this.name,
    required this.specialization,
    required this.experience,
    required this.rating,
    required this.fee,
    required this.isAvailable,
  });
}

final List<Doctor> doctors = [
    Doctor(
      name: 'Dr. Arlene Mccoy',
      specialization: 'Gynecologist',
      experience: '5 years Exp',
      rating: 4.8,
      fee: 180,
      isAvailable: true,
    ),
    Doctor(
      name: 'Dr. Kevon Lane',
      specialization: 'Gynecologist',
      experience: '5 years Exp',
      rating: 4.9,
      fee: 200,
      isAvailable: true,
    ),
  ];