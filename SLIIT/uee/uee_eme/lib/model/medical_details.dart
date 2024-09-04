class MedicalDetails {
  String fullName;
  String phone;
  String bloodType;
  String allergies;
  String emergencyContact;

  MedicalDetails({
    required this.fullName,
    required this.phone,
    required this.bloodType,
    required this.allergies,
    required this.emergencyContact,
  });

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'phone': phone,
      'bloodType': bloodType,
      'allergies': allergies,
      'emergencyContact': emergencyContact,
    };
  }

  factory MedicalDetails.fromMap(Map<String, dynamic> map) {
    return MedicalDetails(
      fullName: map['fullName'],
      phone: map['phone'],
      bloodType: map['bloodType'],
      allergies: map['allergies'],
      emergencyContact: map['emergencyContact'],
    );
  }
}
