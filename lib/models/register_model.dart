class RegisterModel {
  String name;
  String executive;
  String payment;
  String phone;
  String address;
  double totalAmount;
  double discountAmount;
  double advanceAmount;
  double balanceAmount;
  String dateNdTime;
  String id;
  List<int> male;
  List<int> female;
  String branch;
  List<int> treatments;

  RegisterModel({
    required this.name,
    required this.executive,
    required this.payment,
    required this.phone,
    required this.address,
    required this.totalAmount,
    required this.discountAmount,
    required this.advanceAmount,
    required this.balanceAmount,
    required this.dateNdTime,
    required this.id,
    required this.male,
    required this.female,
    required this.branch,
    required this.treatments,
  });

  // Method to convert JSON to RegisterModel object
  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      name: json['name'],
      executive: json['executive'],
      payment: json['payment'],
      phone: json['phone'],
      address: json['address'],
      totalAmount: json['total_amount'],
      discountAmount: json['discount_amount'],
      advanceAmount: json['advance_amount'],
      balanceAmount: json['balance_amount'],
      dateNdTime: json['date_nd_time'],
      id: json['id'],
      male: json['male'].split(',').map((e) => int.parse(e)).toList(),
      female: json['female'].split(',').map((e) => int.parse(e)).toList(),
      branch: json['branch'],
      treatments:
          json['treatments'].split(',').map((e) => int.parse(e)).toList(),
    );
  }

  // Method to convert RegisterModel object to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'executive': executive,
      'payment': payment,
      'phone': phone,
      'address': address,
      'total_amount': totalAmount,
      'discount_amount': discountAmount,
      'advance_amount': advanceAmount,
      'balance_amount': balanceAmount,
      'date_nd_time': dateNdTime,
      'id': id,
      'male': male.join(','),
      'female': female.join(','),
      'branch': branch,
      'treatments': treatments.join(','),
    };
  }
}
