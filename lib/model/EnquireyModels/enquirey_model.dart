class EnquiryResponseModel {
  final dynamic status;
  final dynamic message;
  final dynamic enquiryId;
  final EnquiryDetails? enquiryDetails;

  EnquiryResponseModel({
    required this.status,
    required this.message,
    required this.enquiryId,
    this.enquiryDetails,
  });

  factory EnquiryResponseModel.fromJson(Map<dynamic, dynamic> json) {
    return EnquiryResponseModel(
      status: json['status'] as dynamic,
      message: json['message'] as dynamic,
      enquiryId: json['enquiry_id'] as dynamic,
      enquiryDetails: json['enquiry_details'] != null
          ? EnquiryDetails.fromJson(json['enquiry_details'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'enquiry_id': enquiryId,
      'enquiry_details': enquiryDetails?.toJson(),
    };
  }
}

class EnquiryDetails {
  final dynamic id;
  final dynamic firmName;
  final dynamic name;
  final dynamic email;
  final dynamic mobile;
  final dynamic address;
  final dynamic subject;
  final dynamic requirement;

  EnquiryDetails({
    required this.id,
    required this.firmName,
    required this.name,
    required this.email,
    required this.mobile,
    required this.address,
    required this.subject,
    required this.requirement,
  });

  factory EnquiryDetails.fromJson(Map<dynamic, dynamic> json) {
    return EnquiryDetails(
      id: json['id'] as dynamic,
      firmName: json['firm_name'] as dynamic,
      name: json['name'] as dynamic,
      email: json['email'] as dynamic,
      mobile: json['mobile'] as dynamic,
      address: json['address'] as dynamic,
      subject: json['subject'] as dynamic,
      requirement: json['requirement'] as dynamic,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firm_name': firmName,
      'name': name,
      'email': email,
      'mobile': mobile,
      'address': address,
      'subject': subject,
      'requirement': requirement,
    };
  }
}
